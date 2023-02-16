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
            
            
            
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.orange.opacity(0.90))
                    .shadow(radius: 20)
                    .padding(45.0)
                    .background(LinearGradient(colors: [Color.white , Color.white.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .background(LinearGradient(colors: [Color.blue , Color.blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .background(LinearGradient(colors: [Color.green.opacity(0.4) , Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
           
                
               
                           
            VStack{
            
                Text("SIGN IN")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                
                
                TextField("email", text: $email)
                    .font(.title)
                    .padding(15.0)
                        .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                      .stroke(.black, lineWidth: 2.0)
                                      .shadow(radius: 20)
                                      .background(.white)
  )
                        .padding()
                    
                    
                SecureField("password", text: $password)
                    .font(.title)
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
                        .font(.title)
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
                .fill(Color.pink.opacity(0.40))
                .shadow(radius: 20)
                .padding(45.0)
                .background(LinearGradient(colors: [Color.white , Color.white.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .background(LinearGradient(colors: [Color.blue , Color.blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .background(LinearGradient(colors: [Color.green.opacity(0.4) , Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            VStack{
        Text("SIGN UP")
                    .foregroundColor(.white)
                    .font(.largeTitle)
        
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
                        .stroke(.black, lineWidth: 2.0).shadow(radius: 20)
                        .background(.white))
                      .padding()
        Button(action: {signUp(email: email, password: password)}){
            Text("signUp")
        }
        .background(RoundedRectangle(cornerRadius: 5.0,style: .continuous) .fill(LinearGradient(colors: [.white,.white], startPoint: .top, endPoint: .bottomTrailing)).frame(width: 70, height: 30, alignment: .center))
        .foregroundColor(.black.opacity(0.8))
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
    @Binding var userIsLoggedIn : Bool
    static var previews: some View {
        LoginView()
    }
}*/
