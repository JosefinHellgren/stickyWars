//
//  ProfileViewModel.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth



class UserModel: ObservableObject {
    @Published var user: User?
    
    private var db = Firestore.firestore()
    
    func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("UserInfo").document(userId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else {
                print("Error fetching user data: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            let user = User (
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                score : data["score"] as? Int ?? 0
            )
            self.user = user
        }
    }
    
    
    func updateScore() {
        guard let currentUser = Auth.auth().currentUser?.uid else {
            return
        }
        
        if let user = user {
            let newScore = user.score + 1
            db.collection("UserInfo").document(currentUser).updateData(["score": newScore]) { error in
                if let error = error {
                    print("Error updating user score: \(error.localizedDescription)")
                }
            }
        }
    }
}




