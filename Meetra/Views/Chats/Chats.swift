//
//  Chats.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct Chats: View {
    @StateObject var chatVM = ChatViewModel()
    
    var body: some View {
        NavigationView {
            
            ZStack {
                if chatVM.loading && !chatVM.loaded {
                    Loading()
                } else {
                    
                    List {
                        
                        if chatVM.showSearchField {
                            HStack {
                                Spacer()
                                ChatSearch()
                                    .environmentObject(chatVM)
                                    .padding(.top, 18)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets())
                                Spacer()
                            }
                        }
                        
                        // if the search bar is opened this view should be pinned using section
                        VStack(alignment: .leading, spacing: 20) {
                            Text( NSLocalizedString("interlocutors", comment: ""))
                                .kerning(0.18)
                                .foregroundColor(.black)
                                .font(.custom("Inter-SemiBold", size: 18))
                                .padding(.leading, 26)
                            
                            Interlocutors(interlocutors: chatVM.interlocutors)
                            
                        }.padding(.vertical, 18)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        
                        
                        Text( NSLocalizedString("messages", comment: ""))
                            .kerning(0.18)
                            .foregroundColor(.black)
                            .font(.custom("Inter-SemiBold", size: 18))
                            .padding(.leading, 26)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        
                        ForEach(chatVM.chats, id: \.id) { chat in
                            ChatListCell(chat: chat)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .onAppear(perform: {
                                    if chat.id == chatVM.chats.last?.id && !chatVM.loadingPage {
                                        chatVM.getChatList()
                                    }
                                })
                        }
                        
                        if chatVM.loadingPage {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }.listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                        }
                        
                    }.listStyle(.plain)
                        .padding(.top, 1)
                        .refreshable {
                            chatVM.getChatScreen()
                        }
                }
            }.alert(isPresented: $chatVM.showAlert, content: {
                Alert(title: Text("Error"), message: Text(chatVM.alertMessage), dismissButton: .default(Text("Got it!")))
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text(NSLocalizedString("chats", comment: ""))
                .kerning(0.56)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(10), trailing: HStack( spacing: 20) {
                    Button {
                        withAnimation {
                            chatVM.showSearchField.toggle()
                        }
                        
                        chatVM.search = ""
                        
                    } label: {
                        Image("icon_search")
                            .foregroundColor(chatVM.showSearchField ? AppColors.accentColor : .black)
                    }
                    
                    Button {
                        
                    } label: {
                        Image("icon_ring")
                            .foregroundColor(.black)
                    }
                })
        }.navigationViewStyle(.stack)
            .gesture(DragGesture().onChanged({ _ in
                UIApplication.shared.endEditing()
            }))
    }
}

struct Chats_Previews: PreviewProvider {
    static var previews: some View {
        Chats()
    }
}
