#!/bin/bash

package=$1

# Declare the dictionary of operating systems commoly used in DevOps Environment.
declare -A myOS
myOS["RHEL"]="yum"
myOS["Ubuntu"]="apt"
myOS["SUSE"]="zypper"

# Iterate over the operating systems dictionary.
for os in "${!myOS[@]}"; do

  # Declare the value in PackageInstaller variable.
  PackageInstaller="${myOS[$os]}"

  # Checking for PackageInstaller is exist on OS.
  which $PackageInstaller &>> /dev/null

  # Cheking if the package manager is exist in the dictionary of OS or the OS is not compatible.
  if [ $? -eq 0 ]; then

          # For RedHat Enterprise Linux Operating System flavours.
          if [ "$os" = "RHEL" ]; then

                  # Found RHEL is as a match.
                  yum list installed ${package}* &>> /dev/null
                  # Condition match if the Package is already installed.
                  if [ $? -eq 0 ]; then

                          # Loop to iterate over each match of similar Package name, and printing date as required.
                          for i in `yum list installed ${package}* | grep -A 100 "Installed Packages" | tail -n +2 | awk '{print $1}'`; do
                                  InstallDate=`rpm -qi ${i} | grep "Install Date" | awk -F': ' '{print $2}'`
                                  echo
                                  echo "Package \"$i\" already installed on \"$InstallDate\""
                                  echo
                          done

                  # Need to installe Package if unavailable.
                  else
                          yum install $package -y &>> /dev/null
                          if [ $? -eq 0 ]; then
                                  echo
                                  echo "Package \"$package\" not found..!"
                                  echo
                                  echo "Package \"$package\" installed sucessfully."
                                  echo

                          # If full package name is not provided then using asterisk(*)
                          # to prevent skip the matching name packages to get installed.
                          else
                                  yum install ${package}* -y &>> /dev/null

                                  # If provided Package name is incorrect.
                                  if [ $? -ne 0 ]; then
                                          echo
                                          echo "Error: Unable to find a match: \"$package\""
                                          echo
                                  else
                                          echo
                                          echo "Package \"$package\" not found..!"
                                          echo
                                          echo "Package \"${package}*\" is installed sucessfully."
                                          echo
                                  fi
                          fi


                  fi


          # For SUSE Operating System flavours.
          elif [ "$os" = "SUSE" ]; then
                  # Getting package installation status.
                  rpm -qi $package &>> /dev/null
                  if [ $? -eq 0 ]; then
                          # Getting date of installed package.
                          InstallDate=`rpm -qi $package | grep "Install Date" | awk -F': ' '{print $2}'`

                          echo
                          echo "Package \"$package\" already installed on \"$InstallDate\""
                          echo

                  # Need to installe Package if unavailable.
                  else
                          zypper --non-interactive install $package &>> /dev/null
                          if [ $? -eq 0 ]; then
                                  echo
                                  echo "Package \"$package\" not found..!"
                                  echo
                                  echo "Package \"$package\" installed sucessfully."
                                  echo
                          else
                                  zypper --non-interactive install ${package}* -y &>> /dev/null
                                  # If provided Package name is incorrect.
                                  if [ $? -ne 0 ]; then
                                          echo
                                          echo "No provider of \"$package\" found."
                                          echo
                                  else
                                          echo
                                          echo "Package \"$package\" not found..!"
                                          echo
                                          echo "Package \"${package}*\" is installed sucessfully."
                                          echo
                                  fi
                          fi
                  fi

          # For Ubuntu Operating System flavours.
          elif [ "$os" = "Ubuntu" ]; then
                  # Getting package installation status.
                  status=`dpkg-query --show --showformat='${Status}\n' ${package} 2>> /dev/null`
                  if [[ $status == "install ok installed" ]]; then

                          # Getting date of installed package.
                          InstallDate=`stat -c '%y' /var/lib/dpkg/info/${package}.list 2>> /dev/null| sed 's/ +0000//'`
                          echo
                          echo "Package \"$package\" already installed on \"$InstallDate\""
                          echo

                  # Need to installe Package if unavailable.
                  else
                          apt install $package -y &>> /dev/null
                          if [ $? -eq 0 ]; then
                                  echo
                                  echo "Package \"$package\" not found..!"
                                  echo
                                  echo "Package \"$package\" installed sucessfully."
                                  echo

                          ## If full package name is not provided then using asterisk(*)
                          # to prevent skip the matching name packages to get installed.
                          else
                                  apt install ${package}* -y &>> /dev/null
                                  # If provided Package name is incorrect.
                                  if [ $? -ne 0 ]; then
                                          echo
                                          echo "E: Unable to locate package \"$package\""
                                          echo
                                  else
                                          echo
                                          echo "Package \"$package\" not found..!"
                                          echo
                                          echo "Package \"${package}*\" is installed sucessfully."
                                          echo
                                  fi
                          fi

                  fi

          else
                  echo
                  echo Supported Operating systems: RHEL/SUSE/Ubuntu
                  echo

          fi

  fi
done
