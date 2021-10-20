## Deploying the MariaDB container

0. Install docker (preferably for CLI) and docker-compose.
1. After cloning this repository, execute `cd build` and `sudo docker-compose up -d`.
2. You can connect to the database using software, such as MySQL Workbench or DBeaver on port 3306 using the credentials found in the docker-compose.yaml.

## How to connect to AWS EC2 instance which hosts MariaDB

1.	You can use an SSH client such as PuTTY or MobaXterm to connect to the EC2 instance via ssh or straight from the command line.
2.	For the connection, the private key that were sent to each team member ICL email are required.
3.	The connection string is the following:
   `ssh -i "fuelopt.pem" ec2-user@ec2-3-8-3-44.eu-west-2.compute.amazonaws.com`
	If you are using an ssh client, make sure that you insert the following info:
	***Private key***: browse on your local storage and select the private key fuelopt.pem
	***Hostname***:  ec2-3-8-3-44.eu-west-2.compute.amazonaws.com	
	***User***: ec2-user
	***IPv4***: 3.8.3.44

The OS used on the VM is Linux, and the user also has root access, so be careful.

You can connect directly to MariaDB with the following steps:
1.	For convenience, you can download an RDBMS Client, such as DBeaver, for your connection or through the command line via the mysql command.
2.	The following credentials should be used to connect to the database from the application
  ***Hostnam***e:  ec2-3-8-3-44.eu-west-2.compute.amazonaws.com
  ***IPv4***: 3.8.3.44
  ***DB Use***r: user
  ***DB password***: password

Don’t hesitate to message Marcos if you are having any issues.

