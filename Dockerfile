# VERSION 1.0.0

FROM registry.access.redhat.com/ubi8/python-36
LABEL maintainer="Venkatesh Karadbhajne <venkateshkaradbhajne@fico.com>"

USER root

#Installing JDK 11
ADD jdk-11.0.12_linux-x64_bin.rpm /opt/jdk-11.0.12_linux-x64_bin.rpm
RUN rpm -ivh /opt/jdk-11.0.12_linux-x64_bin.rpm
RUN rm -f /opt/jdk-11.0.12_linux-x64_bin.rpm
RUN java -version



RUN mkdir -p /opt/scripts
RUN groupadd docker -g 8000 \
    && useradd -u 9000 -g 8000 blaze \
    && chown -R blaze:docker /opt

# Add Tini
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /opt/scripts
RUN chmod +x /opt/scripts/tini
ADD bootstrap.sh /opt/scripts/bootstrap.sh
RUN chmod +x /opt/scripts/*.sh

# Install Kit
COPY build_data/*.bin /opt/blaze_kit_installer.bin 
RUN chmod +x /opt/blaze_kit_installer.bin
RUN mkdir /opt/kit
# RUN /opt/blaze_kit_installer.bin -i silent -DUSER_INSTALL_DIR=/opt/kit
COPY build_data/keys.properties /opt/kit/license/com/blazesoft/licenseKeys/keys.properties
RUN rm /opt/blaze_kit_installer.bin

#Installing WebLogic
RUN mkdir /opt/weblogic
WORKDIR /opt/weblogic
USER blaze
ADD oraInst.loc /opt/oraInst.loc
ADD weblogic-install.rsp /opt/weblogic-install.rsp
ADD fmw_14.1.1.0.0_wls_lite_generic.jar /opt/weblogic/fmw_14.1.1.0.0_wls_lite_generic.jar
RUN java -jar fmw_14.1.1.0.0_wls_lite_generic.jar -silent -responseFile /opt/weblogic-install.rsp -invPtrLoc /opt/oraInst.loc

#Creating WebLogic domain
RUN mkdir -p /opt/app/oracle/middleware/user_projects/domains/blaze_admin
ADD create_weblogic_domain.py /opt/create_weblogic_domain.py
WORKDIR /opt/app/oracle/middleware/wlserver/common/bin
RUN chmod +x wlst.sh
RUN ./wlst.sh /opt/create_weblogic_domain.py
RUN mkdir -p /opt/app/oracle/middleware/user_projects/domains/blaze_admin/servers/AdminServer/security
ADD boot.properties /opt/app/oracle/middleware/user_projects/domains/blaze_admin/servers/AdminServer/security/boot.properties

WORKDIR /opt/scripts
CMD ["bin/sh"]