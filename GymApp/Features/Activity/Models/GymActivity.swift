//
//  GymActivity.swift
//  Wellish
//

import Foundation
import FirebaseFirestore

public struct GymActivity: Activity {

    // MARK: - Core Properties

    public let id: String
    public var name: String
    public var description: String?
    public var createdAt: Date
    public var updatedAt: Date
    public var tags: [String]
    public var source: ActivitySource
    public var globalActivityId: String?
    public var shareable: Bool
    public var clubId: String?
    public var creator: String?
    public var imageURL: String?

    // MARK: - Activity Protocol

    public var activityType: ActivityCategory { .gym }

    public var icon: String { "dumbbell.fill" }

    public var colorHex: String { "3B82F6" }

    // MARK: - Gym-Specific Properties

    public var sets: [RoutineSet]
    public var category: ExerciseCategory?
    public var estimatedDurationMinutes: Int?
    public var primaryMuscles: [ExerciseMuscle]
    public var secondaryMuscles: [ExerciseMuscle]
    public var estimatedCaloriesValue: Int?
    public var isPremiumRoutine: Bool
    public var difficulty: ExerciseDifficulty?

    // MARK: - Activity Protocol Computed Properties

    public var estimatedDuration: Int? { estimatedDurationMinutes }
    public var estimatedCalories: Int? { estimatedCaloriesValue }

    // MARK: - Computed Properties

    public var estimatedVolumeKg: Double {
        sets.reduce(0) { $0 + $1.estimatedVolumeKg }
    }

    public var totalSeriesCount: Int {
        sets.reduce(0) { $0 + $1.series.count }
    }

    public var totalReps: Int {
        sets.reduce(0) { $0 + $1.totalReps }
    }

    public var formattedVolume: String {
        NumberFormatter.localizedString(
            from: NSNumber(value: estimatedVolumeKg),
            number: .decimal
        ) + " kg"
    }

    public var primaryMusclesDisplay: String {
        primaryMuscles.isEmpty ? "—" : primaryMuscles.map(\.rawValue).joined(separator: ", ")
    }

    public var secondaryMusclesDisplay: String {
        secondaryMuscles.isEmpty ? "—" : secondaryMuscles.map(\.rawValue).joined(separator: ", ")
    }

    public var isToday: Bool {
        Calendar.current.isDateInToday(createdAt)
    }

    public var daysOld: Int {
        Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
    }

    // MARK: - Init

    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        sets: [RoutineSet] = [],
        tags: [String] = [],
        category: ExerciseCategory? = nil,
        difficulty: ExerciseDifficulty? = nil,
        estimatedDurationMinutes: Int? = nil,
        primaryMuscles: [ExerciseMuscle] = [],
        secondaryMuscles: [ExerciseMuscle] = [],
        estimatedCalories: Int? = nil,
        source: ActivitySource = .created,
        globalActivityId: String? = nil,
        shareable: Bool = false,
        clubId: String? = nil,
        creator: String? = nil,
        isPremiumRoutine: Bool = false,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sets = sets
        self.tags = tags
        self.category = category
        self.difficulty = difficulty
        self.estimatedDurationMinutes = estimatedDurationMinutes
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.estimatedCaloriesValue = estimatedCalories
        self.source = source
        self.globalActivityId = globalActivityId
        self.shareable = shareable
        self.clubId = clubId
        self.creator = creator
        self.isPremiumRoutine = isPremiumRoutine
        self.imageURL = imageURL
    }

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case createdAt, updatedAt
        case sets, tags
        case category, difficulty
        case estimatedDurationMinutes
        case primaryMuscles, secondaryMuscles
        case estimatedCaloriesValue = "estimatedCalories"
        case source, globalActivityId
        case shareable, clubId, creator
        case isPremiumRoutine, imageURL
    }

    // MARK: - Firestore Serialization

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "activityType": activityType.rawValue,
            "activityTypeKey": "gym",
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "sets": sets.map { $0.toDictionary() },
            "tags": tags,
            "source": source.rawValue,
            "shareable": shareable,
            "isPremiumRoutine": isPremiumRoutine,
            "primaryMuscles": primaryMuscles.map(\.rawValue),
            "secondaryMuscles": secondaryMuscles.map(\.rawValue)
        ]

        if let description = description { dict["description"] = description }
        if let category = category { dict["category"] = category.rawValue }
        if let difficulty = difficulty { dict["difficulty"] = difficulty.rawValue }
        if let duration = estimatedDurationMinutes { dict["estimatedDurationMinutes"] = duration }
        if let calories = estimatedCaloriesValue { dict["estimatedCalories"] = calories }
        if let creator = creator { dict["creator"] = creator }
        if let globalActivityId = globalActivityId { dict["globalActivityId"] = globalActivityId }
        if let clubId = clubId { dict["clubId"] = clubId }
        if let imageURL = imageURL { dict["imageURL"] = imageURL }

        return dict
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension GymActivity {
    public static var example: GymActivity {
        GymActivity(
            name: "Empuje de pecho",
            description: "Rutina de empuje enfocada en pecho, hombros y triceps.",
            sets: [
                RoutineSet(
                    exerciseId: "8B747E73-EF22-4B53-8FBA-279B217C9D9F",
                    exerciseName: "Press de banca con barra",
                    series: [
                        Serie(repetitions: 10, idealWeightKg: 60, restSeconds: 90),
                        Serie(repetitions: 8, idealWeightKg: 70, restSeconds: 90),
                        Serie(repetitions: 6, idealWeightKg: 80, restSeconds: 120)
                    ]
                ),
                RoutineSet(
                    exerciseId: "82CCB4F1-726C-434E-B7B2-D8EB70078CC4",
                    exerciseName: "Aperturas con mancuernas",
                    series: [
                        Serie(repetitions: 12, idealWeightKg: 16, restSeconds: 60),
                        Serie(repetitions: 12, idealWeightKg: 16, restSeconds: 60),
                        Serie(repetitions: 12, idealWeightKg: 16, restSeconds: 60)
                    ]
                )
            ],
            tags: ["pecho", "empuje", "hipertrofia"],
            category: .hipertrofia,
            difficulty: .intermedio,
            estimatedDurationMinutes: 55,
            primaryMuscles: [.pectorales],
            secondaryMuscles: [.triceps, .deltoidesAnteriores],
            estimatedCalories: 320,
            source: .global,
            isPremiumRoutine: false
        )
    }
}
#endif
