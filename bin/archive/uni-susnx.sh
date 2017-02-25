#/bin/bash 
ssh -f -N -C -c arcfour,blowfish-cbc -L 5922:susnx.ziti.uni-heidelberg.de:22 d8r@kde04.urz.uni-heidelberg.de
ssh kuck@localhost -p 5922 -c arcfour,blowfish-cbc -C
