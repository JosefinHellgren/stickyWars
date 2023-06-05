//
//  LoginView.swift
//  stickyWars
//
//  Created by Elin Simonsson on 2023-06-05.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var email : String = ""
    @State var password : String = ""
    @Binding var userIsLoggedIn : Bool
    var userModel = UserModel()
    
    
    @State var signUpViewShow : Bool = false
    var body: some View {
        
        ZStack{
            LinearGradient(colors: [Color.purple.opacity(0.5) , Color.yellow.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("globform")
                    .resizable()
                    .scaledToFit()

                TextField("email", text: $email)
                    .padding(15.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                        .stroke(.black, lineWidth: 2.0)
                        .shadow(radius: 20)
                        .background(.white)
                    )
                    .padding()
            
                SecureField("password", text: $password)
                    .padding(15.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                        .stroke(.black, lineWidth: 2.0)
                        .shadow(radius: 20)
                        .background(.white)
                    )
                    .padding()
                
                Button(action: {
                    logIn(email: email, password: password)}){
                        Text("Login")
                    }.background(RoundedRectangle(cornerRadius: 5.0,style: .continuous) .fill(LinearGradient(colors: [.white,.white], startPoint: .top, endPoint: .bottomTrailing)).frame(width: 70, height: 30, alignment: .center))
                    .foregroundColor(.black)
                
                HStack{
                    Text("Not yet signed up? ")
                    
                        .foregroundColor(.white)
                    Button(action: {signUpViewShow = true}){
                        Text("Sign Up")
                    }
                    .foregroundColor(.white)
                    
                    .padding()
                    .sheet(isPresented: $signUpViewShow, content: {
                        SignUpView(userIsLoggedIn: $userIsLoggedIn)
                    })
                }
            }
        }
    }
    
    func logIn (email : String , password : String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                userModel.fetchUserData()
                userIsLoggedIn.toggle()
            }
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
