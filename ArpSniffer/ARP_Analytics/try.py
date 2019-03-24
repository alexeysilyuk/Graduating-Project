from firebase import firebase

import time
import random
import string
import socket 

f = firebase.FirebaseApplication('https://safewifi-a7dc0.firebaseio.com', None)


# p = 'PlayBoy,PornPlanner,MyPornBible,Badjojo,FindTubes,LasMejoresWebsPorno,PornMD,Nudevista,AdultVideoFinder,IPornTV,xVideos,PornHub,amster,XNXX,YouPorn,YouJizz,HClips,Porn,TnaFlix,Tube8,Spankbang,DrTuber,VPorn,Spankwire,KeezMovies,Nuvid,SunPorno,PornHD,Porn300,SexVid,ZbPorn,XXXBunker,Mofosex,Xbabe,PornDroids,TubSexer,BeFuck,MasseurPorn,Hdmovz,PornRox,PornMaki,Pornid,Inxporn,Slutload,ProPorn,FakePorn,Pornhost,HandjobHub,TubeV,Vpornvideos,DansMovies,Fapdu,Porn7,Rude,24Porn,FreudBox,PornHeed,Orgasm,PornRabbit,MadThumbs,Fux,Eroxia,DeviantClip,Xxvids,H2porn,TopFreePornVideos,ApeTube,MetaPorn,ElephantTube,Long,PornerBros'
# p = 'jackpotparadise,vegasparadise,betatcasino,casino,partycasino,slottyvegas,dunder,betway,royalpanda'
p = 'Tinder,Omegle,Chatroulette,7 Cups,Airtime,BongaCams,CAM4,Chat-Avenue,Discord,Chaturbate,Flirt4free,Gitter,Google Hangouts,HipChat,LiveJasmin,Meebo Rooms,MyFreeCams,Megacams,Rounds,Streamup,Talkomatic,Tinychat,TokBox,Userplane,Woo Media,Xfire'

lis = p.split(",")

g = {'Chatting': lis}
f.patch('/Black_List_Web_Site',g)

# try:
#     host_name , alias, addresslist = socket.gethostbyaddr(ip)
#     host_ip = socket.gethostbyname(host_name) 
#     print("Hostname :  ",host_name) 
#     print("IP : ",host_ip)
# except:
#     pass