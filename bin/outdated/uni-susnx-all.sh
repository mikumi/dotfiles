#/bin/bash 
ssh -f -C -N -c arcfour,blowfish-cbc -L 8814:susnx.ziti.uni-heidelberg.de:8814 kuck@localhost -p 5922
ssh -f -C -N -c arcfour,blowfish-cbc -L 8815:susnx.ziti.uni-heidelberg.de:8815 kuck@localhost -p 5922
ssh -f -C -N -c arcfour,blowfish-cbc -L 3307:sussrv01.ziti.uni-heidelberg.de:3306 kuck@localhost -p 5922
