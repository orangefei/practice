#!/bin/bash

# usage ()
# {
	# echo "Usage: $0 xxx(like xxx)......"
	# exit 1
# }

#if [ $# -ne 1 ];then    
#    echo "Usage: $0 sftp_project_name(like bjshouhang )......"
#	exit 1
#fi

# dir=/data/www/crfsftp
#dir=/data/www/chroot
dir=/data/www/sftp_chroot
#timestamp=` date "+%Y-%m-%d" `
timestamp=` date "+%F %T" `


echo -n "Enter the name of the SFTP project you want to create[like bjshouhang]: "  	
read ans1
echo -n "add by who? [like test]: "  	
read ans2

# pwd=`mkpasswd -R 12`  ubuntu
pwd=`mkpasswd -l 12`   # centos
#echo "$ans1 $pwd        \"add by $ans2\" $timestamp" >> record.txt

#useradd -d $dir/$1 -g chroot -s /bin/false $1
#groupadd sftp
useradd -d $dir/$ans1 -g sftp -s /bin/false $ans1

if [ $? -eq 0 ]; then
  echo "$ans1   $pwd    \"add by $ans2\"  $timestamp" >> record.txt

  chown root $dir/$ans1
  chmod 750 $dir/$ans1
  cd $dir/$ans1
  # mkdir {upload,pub}
  mkdir upload
  chmod a+w upload -R upload

  if grep -q $ans1 /etc/ssh/sshd_config; then
    echo "User already exists, pls check it!"
  else
    echo "
Match user $ans1
ChrootDirectory $dir/$ans1
ForceCommand internal-sftp
Match Group sftp" | tee -a /etc/ssh/sshd_config
  fi

else
  echo "add sftp [ $ans1 ] failed, pls check it!!!"
fi

#if grep -q $ans1 /etc/ssh/sshd_config; then
#  echo "User already exists, pls check it!"
#else
#  echo "
#Match user $ans1
#ChrootDirectory $dir/$ans1
#ForceCommand internal-sftp
#Match Group sftp" | tee -a /etc/ssh/sshd_config
#fi

echo "$ans1:$pwd" | chpasswd

/etc/init.d/sshd  reload


exit 0
