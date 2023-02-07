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
    @Binding var userIsLoggedIn : Bool
   
   
    @State var signUpViewShow : Bool = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30, style: .continuous).foregroundStyle(
                LinearGradient(colors: [.white,.black], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 400, height: 1000)
                .rotationEffect(.degrees(135))
                .offset(y:-35)
                
                .padding(20.0)
                           
            VStack{
            
                Text("SIGN IN")
                    .font(.largeTitle)
                    .foregroundColor(.purple)
                
                
                TextField("email", text: $email)
                    .padding(18.0)
                      .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                    .stroke(.purple, lineWidth: 4.0))
                    
                    .padding()
                SecureField("password", text: $password)
                    .padding(18.0)
                      .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                    .stroke(.purple, lineWidth: 4.0))
                      .padding()
                Button(action: {
                    logIn(email: email, password: password)}){
                    Text("Login")
                    }.background(RoundedRectangle(cornerRadius: 5.0,style: .continuous) .fill(LinearGradient(colors: [.white,.black], startPoint: .top, endPoint: .bottomTrailing)).frame(width: 150, height: 40, alignment: .center))
                    .foregroundColor(.black)
                    
                   
                    
                
                
                HStack{
                Text("Not yet signed up? ")
                        .foregroundColor(.purple)
                Button(action: {signUpViewShow = true}){
                    Text("Sign Up")
                    
                    
                }
                .foregroundColor(.purple)
                    
                    .padding()
                .sheet(isPresented: $signUpViewShow, content: {
                    SignUpView(userIsLoggedIn: $userIsLoggedIn)
                })
                }
                
                
                
            }
            
        
        }.background(.black)
    }
    func logIn (email : String , password : String){
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
         
            if error != nil {
                           print(error?.localizedDescription ?? "")
                       } else {
                           print("success")
                           userIsLoggedIn.toggle()
                       }
        }
        
        
    }



}
struct SignUpView: View{
    @State var email : String = ""
    @State var password : String = ""
    @Binding var userIsLoggedIn : Bool
  
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
                print("secsessed creating user ")
                
                userIsLoggedIn.toggle()
                
                
            }else{
                print("error with creating user")
            }
            
        }
        
        
        
        
    }

}


/*struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}*/
