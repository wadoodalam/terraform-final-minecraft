# Run a minecraft server(JAVA) via AWS  without opening the AWS Management Console.

## Background
We will be creating and running a minecraft server via creating an AWS EC2 instance. The AWS instance will be created using Terraform and we will be writing a .tf file to do so(you will need to establish a connection with AWS on your local machine). Once we have the EC2 instance running, we will then run a bash script which will take in the public dns as an argument and subsequently install/start the minecraft server each time it is executed. Let us get into it now.
## Requirements
In order to complete the aforementioned tasks we would would need to have the following things available:
* Terraform
* AWS
* Linux CLI
* Vim Editor
* AWS connection credentials which can be found when start your AWS lab
* nmap for testing the minecraft server
* A code editor would be helpful but not necessary

## Diagram of the major steps in the pipeline
![CS312 Final-Minecraft drawio](https://github.com/wadoodalam/terraform-final-minecraft/assets/42946189/f8dd9d95-2a5e-4401-9ba6-27d52d761e4a)


## Guidelines


  * Setup the Credential file
    1. Start you AWS lab
    2. Click on the "AWS details"![Screenshot 2023-06-12 at 3 25 39 AM](https://github.com/wadoodalam/terraform-final-minecraft/assets/42946189/0f8e50b6-fb3c-4da5-9a42-e9a0418b668a)

    3. Copy the content provided
    4. From you local machine's CLI, navigate to .aws directory using`cd .aws` 
    5. Create/Edit a `credentials` file using `vi credentials`
    6. Paste the content from AWS details into the credentials and save using `:wq`
    7. Note: You would need to repeat all the previous step each time your AWS lab is started/re-stared

  
  
   
   
  * Create a main.tf file
     1. Create a file called `main.tf` with the configuration you want.
     2. This file will include the configuration for AWS instance, including region, link to 
          * The configuration details for the AWS instance (AMI, Size, etc.)
          * Region
          * Link to the `/.aws/credentials` file
          * Security group 
          * Inbound and Outbound rules
          * Ability to generate a private key to ssh into the instance
          * Output the required IP address and Public DNS for the instance

      3. Your `main.tf` file should look something like this:
<img width="1440" alt="Screenshot 2023-06-12 at 3 35 55 AM" src="https://github.com/wadoodalam/terraform-final-minecraft/assets/42946189/e7a49236-3f06-473a-80b2-7ce2f0af6be6">
<img width="1440" alt="Screenshot 2023-06-12 at 3 36 08 AM" src="https://github.com/wadoodalam/terraform-final-minecraft/assets/42946189/b101c458-3de2-49fc-a7db-542c6297a897">
      4. Please Note that you would need to change the region and the `shared_credentials_files` file path accordingly. 
                                                                 

  * Create a bash script

     1. Create a file called `setup.bash` with the configuration you want.
     2. This script will:
          * Take in the Public DNS as an argument
          * Get the private key
          * ssh into the instance
          * download the appropriate packages required
          * Edit the `eula.txt` file
          * Stop any previously running minecraft server
          * Start the server
      3. Your `setup.bash` file should look something like this:

<img width="867" alt="Screenshot 2023-06-12 at 3 44 55 AM" src="https://github.com/wadoodalam/terraform-final-minecraft/assets/42946189/51c6b5c7-c9be-437b-80bb-2314b44737cd">


  * Execution

     1. Navigate to the directory where you have your `main.tf` and `setup.bash` files via CLI
     2. Run the following commands to get your AWS EC2 instance running:
        1. `terraform fmt`
        2. `terraform init`
        3. `terraform apply`
        4. Answer `yes` to the prompt
     3. Step 2 might take some time but once it is completed, you should get the Public DNS and IP address for your instance. Please save the displayed IP address as we would need it later on to test our server. 
     4. Now, using the Public DNS, execute the script using the following command: `bash setup.bash <your_public_DNS>` 
     5. The script will throw an error the first time as it exits out due to eula.txt file not being edited.
     6. Then, run the script command again:`bash setup.bash <your_public_DNS>` and it will start the server

<img width="665" alt="Screenshot 2023-06-12 at 4 26 52 AM" src="https://github.com/wadoodalam/terraform-final-minecraft/assets/42946189/354b5435-b5f4-4537-8b24-efbd971b2ba8">


  * How to connect to the Minecraft server once it's running
      1. Ensure that you have `nmap` installed on your machine
      2. Copy the IP address you saved previously once you created your instance
      3. Run the following command: `nmap -sV -Pn -p T:25565 <instance_public_ip>`
<img width="734" alt="Screenshot 2023-06-12 at 4 26 35 AM" src="https://github.com/wadoodalam/terraform-final-minecraft/assets/42946189/52f18c15-6c53-4866-b062-2717c48b22df">

  
  * Destruction (If wanted)

    1. `Ctrl + C` out of your script.
    2. Destroy your instance: `terraform destroy`, answer `yes` to the prompt
    3. Delete the private key using this command: `rm -rf private_key.pem`
    4. This should destroy everything and stop the server





