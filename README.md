#Copy the kit installer and the license file to the `build_data` directory. 
#See `build_data/README.md` for more details.

#Download the below artifacts from the box location and keep them in the current folder.
Box location:https://fico.box.com/s/p5p2n19i549fw84grv7qd1r0o6kzn7zq
Artifacts:
1.fmw_14.1.1.0.0_wls_lite_generic.jar
2.jdk-11.0.12_linux-x64_bin.rpm

#Build the docker image.
docker build -t weblogic_java11 .

#Run the docker image.
docker run -p 7001:7001 docker.io/library/weblogic_java11

#URL: Admin console
http://localhost:7001/console
