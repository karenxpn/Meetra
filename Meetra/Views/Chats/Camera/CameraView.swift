//
//  CameraView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 09.05.22.
//

import SwiftUI

struct CameraView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var camera = CameraViewModel()
    
    let action: ((URL, Data) -> Void)
    var body: some View {
        ZStack {
            
            CameraPreview()
                .environmentObject(camera)
                .ignoresSafeArea(.all, edges: .all)
            
            
            if camera.isTaken {
                CameraContentPreview(url: camera.previewURL)
                    .ignoresSafeArea(.all, edges: .all)
            }
            
            
            VStack {
                
                if camera.isTaken {
                    HStack {
                        Button {
                            camera.retakePic()
                        } label: {
                            
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }.padding(.leading)
                        
                        Spacer()
                        
                    }.padding(.top)
                }
                
                if !camera.isTaken && !camera.isRecording {
                    HStack {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }.padding(.leading)
                        
                        
                        Spacer()
                        
                        Button {
                            if camera.position == .back {
                                camera.position = .front
                            } else {
                                camera.position = .back
                            }
                            
                            camera.setUp()
                            
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }.padding(.trailing)
                    }.padding(.top)
                }
                
                Spacer()
                
                HStack {
                    
                    if camera.isTaken {
                        
                        Spacer()
                        
                        Button {
                            if let url = camera.previewURL {
                                action(url, camera.mediaData)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Text(NSLocalizedString("userThisMedia", comment: ""))
                                .foregroundColor(.black)
                                .font(.custom("Inter-SemiBold", size: 14))
                                .kerning(0.12)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }.padding(.trailing)
                        
                    } else {
                        
                        Button {
                            
                            if camera.video {
                                camera.stopRecording()
                                // in the end of taking video -> camera.video need to become false again
                            } else {
                                camera.takePic()
                            }
                            
                        } label: {
                            
                            ZStack {
                                Circle()
                                    .fill( camera.video ? AppColors.accentColor : Color.white)
                                    .frame(width: 75, height: 75)
                                
                                Circle()
                                    .stroke( Color.white, lineWidth: 2)
                                    .frame(width: 85, height: 85)
                                    .shadow(color: Color.clear, radius: 20)
                            }
                            
                        }.simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5).onEnded({ value in
                                if camera.recordPermission == .granted {
                                    camera.video = true
                                    camera.setUp()
                                    camera.startRecordinng()
                                }
                            })
                        )
                    }
                }.frame(height: 75)
                    .padding(.bottom)
                
            }
            
        }.onAppear {
            camera.checkPermission()
            camera.checkAudioPermission()
        }.alert(isPresented: $camera.alert) {
            Alert(title: Text(NSLocalizedString("youFoundInterlocutor", comment: "")),
                  primaryButton: .default(Text(NSLocalizedString("goToSettings", comment: "")), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                  secondaryButton: .cancel(Text(NSLocalizedString("cancel", comment: ""))))
        }.onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if camera.recordedDuration <= 15 && camera.isRecording {
                camera.recordedDuration += 1
            }
            
            if camera.recordedDuration >= 15 && camera.isRecording {
                camera.stopRecording()
            }
        }
    }
}
