//
//  FriendList.swift
//  FriendsFavoriteMovie
//
//  Created by Jeremy Frick on 4/11/24.
//

import SwiftUI
import SwiftData

struct FriendList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Friend.name) private var friends: [Friend]
    
    @State private var newFriend: Friend?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !friends.isEmpty {
                    List {
                        ForEach(friends) { friend in
                            NavigationLink {
                                FriendsDetail(friend: friend)
                            } label: {
                                Text(friend.name)
                            }
                        }
                        .onDelete(perform: deleteFriends)
                    }
                } else {
                    ContentUnavailableView {
                        Label("No Friends, yet...", systemImage: "person.2.slash")
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addFriend) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $newFriend) { friend in
                NavigationStack {
                    FriendsDetail(friend: friend, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select a friend")
                .navigationTitle("Friend")
        }
    }
    
    private func addFriend() {
        withAnimation{
            let newItem = Friend(name: "")
            modelContext.insert(newItem)
            newFriend = newItem
        }
    }
    
    private func deleteFriends(offsets: IndexSet){
        withAnimation{
            for index in offsets {
                modelContext.delete(friends[index])
            }
        }
        }
}

#Preview {
    FriendList()
        .modelContainer(SampleData.shared.modelContainer)
}
