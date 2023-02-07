//
//  LoginView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-02.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    @State var email : String = ""
    @State var password : String = ""
    @State var showArView : Bool = false
    @Binding var isSignedIn : Bool
    @State var signUpViewShow : Bool = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.purple.opacity(0.70))
                
                .padding(20.0)
                           
            VStack{
            
                Text("SIGN IN")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                
                TextField("email", text: $email)
                    .padding(15.0)
                      .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                    .stroke(.pink, lineWidth: 2.0))
                    
                    .padding()
                SecureField("password", text: $password)
                    .padding(15.0)
                      .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                    .stroke(.pink, lineWidth: 2.0))
                      .padding()
                Button(action: {
                    logIn(email: email, password: password)}){
                    Text("Login")
                    }.background(.green)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .cornerRadius(4.0)
                    .padding()
                
                
                HStack{
                Text("Not yet signed up? ")
                        .foregroundColor(.blue)
                Button(action: {signUpViewShow = true}){
                    Text("Sign Up")
                    
                    
                }.background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4.0)
                    .padding()
                .sheet(isPresented: $signUpViewShow, content: {
                    SignUpView(isSignedIn: $isSignedIn)
                })
                }
                
                
                
            }
            
        
        }.background(.green)
    }
    func logIn (email : String , password : String){
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
         isSignedIn = true
          // ...
        }
        
        
    }



}
struct SignUpView: View{
    @State var email : String = ""
    @State var password : String = ""
    @Binding var isSignedIn : Bool
    var body: some View{
        
        ZStack{  RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.pink.opacity(0.70))
                .padding(20.0)
                .background(.blue)
            VStack{
        Text("SIGN UP")
                    .foregroundColor(.white)
                    .font(.largeTitle)
        
       TextField("email", text: $email)
                    .padding(15.0)
                      .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                    .stroke(.white, lineWidth: 2.0))
                      .padding()
        SecureField("password", text: $password)
                    .padding(15.0)
                      .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                    .stroke(.white, lineWidth: 2.0))
                      .padding()
        Button(action: {signUp(email: email, password: password)}){
            Text("signUp")
        }.background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4.0)
                    .padding()
                    .frame(width: 200.0, height: 150.0, alignment: .center)
            }
    }
    }
    
    func signUp(email: String, password: String){
      
        

        Auth.auth().createUser(withEmail: email, password: password) {authresult    ,error in
           
            if (authresult?.user.uid != nil){
                isSignedIn = true
                
                
            }
            
        }
        
        
        
        
    }

}


/*struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}*/
