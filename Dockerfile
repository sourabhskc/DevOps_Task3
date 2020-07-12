# creating image jenkins-k8s:v3
FROM centos:latest
RUN yum install sudo -y
RUN sudo yum install wget -y
# installing git
RUN yum install git -y 
# configuraing jenkins repo
RUN sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
RUN sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
# installing java 
RUN yum install java-11-openjdk.x86_64 -y
RUN yum install initscripts.x86_64 -y
# installing jenkins 
RUN yum install jenkins -y 
# giving jenkins to root power
RUN echo -e "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# starting jenkins
CMD /etc/rc.d/init.d/jenkins start && /bin/bash

# installing kubectl 
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

RUN chmod +x kubectl
RUN mv kubectl /usr/bin/
#  creating folder for copying 
RUN mkdir /root/.kube/
RUN mkdir /root/.minikube/

# copying k8s config file 
COPY config /root/.kube/
# copying all .minikube folder from host to container 
# this file contain "client.key" and "client.cert" file 
COPY .minikube /root/.minikube/
# copying ca.crt in /root/.minikube folder
COPY ca.crt /root/.minikube/
