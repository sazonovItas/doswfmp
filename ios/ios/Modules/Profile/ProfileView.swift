//
//  ProfileView.swift
//  iso
//
//  Created by Xenona on 19/02/2025.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @Binding var profile: Profile?
    
    var body: some View {
        NavigationView {
            VStack {
                if let profile = profile {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(profile.username).font(.title).fontWeight(.bold)
                                    
                                    Text("Email: \(profile.email)").font(.subheadline).foregroundColor(.gray)
                                }.padding(.leading)
                                
                                Spacer()
                                
                                Image(systemName: "person.circle.fill").resizable().scaledToFit().frame(width: 100, height: 100).foregroundColor(.blue).padding(.trailing)
                            }.padding(.top)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Date of Birth: \(profile.dateOfBirth, formatter: dateFormatter)")
                                    .font(.body)
                                    .padding(.horizontal)
                                
                                Text("Gender: \(profile.sex)")
                                    .padding(.horizontal)
                                
                                Text("Country: \(profile.country)").font(.body)
                                    .padding(.horizontal)
                                
                                Text("Member since: \(profile.registeredAt, formatter: dateFormatter)").font(.body)
                                    .padding(.horizontal)
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Description")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                Text(profile.description)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        Text("You are currently offline. Please log in to access you profile.").font(.title2).fontWeight(.bold).foregroundColor(.gray).padding()
                        
                        Button(action: {
                            isLoggedIn = false
                            profile = nil
                        }, label: {
                            Text("Go to Login").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.blue).cornerRadius(10).padding(.horizontal)
                        }).padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            Spacer()
                
            if profile != nil {
                Button(action: {
                    isLoggedIn = false
                    profile = nil
                }) {
                    Text("Log Out").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.red).cornerRadius(10).padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
            
            
        }.navigationTitle("Profile")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct ProfileView_Previews: PreviewProvider {
    
    @State static var my_sample_profile: Profile? = Profile(
        email: "john.doe@example.com",
        username: "john_doe",
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -25, to: Date())!,
        country: "USA",
        sex: "Male",
        description: "A passionate music lover and software developer.",
        registeredAt: Date(),
        favorites: []
    )
    
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(false), profile: .constant(nil))
    }
}
