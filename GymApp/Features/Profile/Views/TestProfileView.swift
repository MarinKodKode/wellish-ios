import SwiftUI

struct ProfileTestView: View {
    @State private var showEditSheet = false
    @State private var showPhotoSheet = false
    @State private var bio = "Lifting weights & chasing progress 🥇"
    @State private var tags = ["Fitness", "Strength", "Cardio", "Nutrition", "Wellness"]
    @State private var selectedProfileIcon = "person.circle.fill"
    @State private var profileIconColor = Color.blue
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header Profile - Instagram Style
                HStack(alignment: .top, spacing: 20) {
                    // Profile Photo
                    Button(action: {
                        showPhotoSheet = true
                    }) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            profileIconColor,
                                            profileIconColor.opacity(0.7)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 90, height: 90)
                                .overlay(
                                    Image(systemName: selectedProfileIcon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(hex: "FFD700"),
                                                    Color(hex: "FF6B6B"),
                                                    Color(hex: "4E73DF")
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                )
                        }
                    }
                    
                    // Bio and Tags Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Zayn Pradipta")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                showEditSheet = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(hex: "252836"),
                                                    Color(hex: "1E222E")
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: "3A3F52"), lineWidth: 1)
                                        )
                                        .frame(width: 36, height: 36)
                                    
                                    Image(systemName: "pencil")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Text(bio)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        // Tags
                        FlowLayouts(spacing: 6) {
                            ForEach(tags, id: \.self) { tag in
                                TagView(text: tag)
                            }
                        }
                        
                        Text("zayn.pradipta@example.com")
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Achievements Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Achievements")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            AchievementCard(
                                icon: "trophy.fill",
                                title: "Week Warrior",
                                subtitle: "7-day streak",
                                gradient: [Color(hex: "FFD700"), Color(hex: "FFA500")]
                            )
                            
                            AchievementCard(
                                icon: "flame.fill",
                                title: "Fire Starter",
                                subtitle: "10 routines",
                                gradient: [Color(hex: "FF6B6B"), Color(hex: "FF8E53")]
                            )
                            
                            AchievementCard(
                                icon: "dumbbell.fill",
                                title: "Strength Pro",
                                subtitle: "50 workouts",
                                gradient: [Color(hex: "4E73DF"), Color(hex: "6F5FDF")]
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // Stats Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Your Stats")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Last 30 days")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        Profile_StatCard(
                            icon: "checkmark.circle.fill",
                            label: "Routines",
                            value: "42",
                            gradient: [Color(hex: "10B981"), Color(hex: "059669")]
                        )
                        
                        Profile_StatCard(
                            icon: "flame.fill",
                            label: "Streak",
                            value: "1d",
                            gradient: [Color(hex: "F59E0B"), Color(hex: "D97706")]
                        )
                        
                        Profile_StatCard(
                            icon: "clock.fill",
                            label: "Workout Time",
                            value: "32h",
                            gradient: [Color(hex: "3B82F6"), Color(hex: "2563EB")]
                        )
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 30)
            }
        }
        .background(Color(hex: "1A1D29"))
        .sheet(isPresented: $showEditSheet) {
            EditProfileSheet(bio: $bio, tags: $tags)
        }
        .sheet(isPresented: $showPhotoSheet) {
            ProfilePhotoSheet(
                selectedIcon: $selectedProfileIcon,
                selectedColor: $profileIconColor
            )
            .presentationDetents([.height(280)])
            .presentationDragIndicator(.visible)
        }
    }
}

struct ProfilePhotoSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedIcon: String
    @Binding var selectedColor: Color
    @State private var showImagePicker = false
    
    let avatarOptions: [(icon: String, color: Color, name: String)] = [
        ("flame.fill", Color(hex: "FF6B6B"), "Fire"),
        ("bolt.fill", Color(hex: "FFD700"), "Lightning"),
        ("leaf.fill", Color(hex: "10B981"), "Nature"),
        ("moon.stars.fill", Color(hex: "6F5FDF"), "Night"),
        ("heart.fill", Color(hex: "FF69B4"), "Heart")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Handle bar
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            Text("Choose Profile Icon")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            // Avatar Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(avatarOptions, id: \.icon) { option in
                    Button(action: {
                        selectedIcon = option.icon
                        selectedColor = option.color
                        dismiss()
                    }) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                option.color,
                                                option.color.opacity(0.7)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                selectedIcon == option.icon ? Color.white : Color.clear,
                                                lineWidth: 3
                                            )
                                    )
                                    .shadow(color: option.color.opacity(0.4), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: option.icon)
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                            }
                            
                            Text(option.name)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Custom Upload Button
                Button(action: {
                    showImagePicker = true
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "252836"),
                                            Color(hex: "1E222E")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color(hex: "4E73DF"),
                                            style: StrokeStyle(lineWidth: 2, dash: [5])
                                        )
                                )
                            
                            Image(systemName: "plus")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(Color(hex: "4E73DF"))
                        }
                        
                        Text("Custom")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(Color(hex: "1A1D29"))
        .sheet(isPresented: $showImagePicker) {
            Text("Image Picker")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "1A1D29"))
        }
    }
}

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var bio: String
    @Binding var tags: [String]
    
    @State private var editableBio: String
    @State private var editableTags: [String]
    @State private var newTag: String = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case bio
        case newTag
    }
    
    init(bio: Binding<String>, tags: Binding<[String]>) {
        self._bio = bio
        self._tags = tags
        self._editableBio = State(initialValue: bio.wrappedValue)
        self._editableTags = State(initialValue: tags.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Bio Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Bio")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "252836"),
                                            Color(hex: "1E222E")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(hex: "3A3F52"), lineWidth: 1)
                                )
                            
                            TextEditor(text: $editableBio)
                                .focused($focusedField, equals: .bio)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(12)
                                .frame(height: 120)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        }
                        .frame(height: 120)
                        
                        Text("\(editableBio.count)/150 characters")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    // Tags Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Tags")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(editableTags.count)/5")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        Text("Add up to 5 tags that describe your fitness journey")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        // Current Tags
                        FlowLayout(spacing: 10) {
                            ForEach(editableTags, id: \.self) { tag in
                                EditableTagView(text: tag) {
                                    editableTags.removeAll { $0 == tag }
                                }
                            }
                        }
                        
                        // Add New Tag
                        if editableTags.count < 5 {
                            HStack(spacing: 12) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(hex: "252836"),
                                                    Color(hex: "1E222E")
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(hex: "3A3F52"), lineWidth: 1)
                                        )
                                    
                                    TextField("Add a tag", text: $newTag)
                                        .focused($focusedField, equals: .newTag)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .submitLabel(.done)
                                        .onSubmit {
                                            addTag()
                                        }
                                }
                                .frame(height: 44)
                                
                                Button(action: addTag) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color(hex: "4E73DF"), Color(hex: "6F5FDF")]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .disabled(newTag.isEmpty || editableTags.count >= 5)
                                .opacity(newTag.isEmpty || editableTags.count >= 5 ? 0.5 : 1.0)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .background(Color(hex: "1A1D29"))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "4E73DF"))
                }
            }
        }
    }
    
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && editableTags.count < 5 && !editableTags.contains(trimmedTag) {
            editableTags.append(trimmedTag)
            newTag = ""
            focusedField = nil
        }
    }
    
    private func saveChanges() {
        bio = editableBio
        tags = editableTags
        dismiss()
    }
}

struct TagView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "4E73DF").opacity(0.3),
                                Color(hex: "6F5FDF").opacity(0.3)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "4E73DF").opacity(0.5),
                                        Color(hex: "6F5FDF").opacity(0.5)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
    }
}

struct EditableTagView: View {
    let text: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.leading, 14)
        .padding(.trailing, 10)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "4E73DF"),
                            Color(hex: "6F5FDF")
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color(hex: "4E73DF").opacity(0.4), radius: 8, x: 0, y: 4)
        )
    }
}

struct FlowLayouts: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

struct AchievementCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradient),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: gradient[0].opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 140, height: 160)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "252836"),
                            Color(hex: "1E222E")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: gradient.map { $0.opacity(0.3) }),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ProfileTestView()
}
