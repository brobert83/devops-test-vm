## This repo contains the local environment used to build the CI process for [devops-test](https://github.com/brobert83/devops-test)

# General notes
- It is a Vagrant machine provisioned with Ansible
- It's purpose is to interact with GCP and TravisCI (to test scripts, encrypt files for travis, etc)
- It is somewhat specific to my local environment (it syncs a directory from my host file system: see the Vagrantfile at the end)

## Requirements
- A GCP project needs to be created before bringing the machine up
- A service account needs to be created 
- A key needs to be created for the service account
   
## Usage
- Edit `Vagrantfile` and change the value of the GCP_PROJECT_NAME variable to the name of your project 
- Place the service account key in `secrets/gcp_project_key.json` 
  - .gitignore has an entry to prevent this directory accidentally be committed
  - this [guide](https://docs.bmc.com/docs/PATROL4GoogleCloudPlatform/10/creating-a-service-account-key-in-the-google-cloud-platform-project-799095477.html) shows how to create a key
- Change or remove the synced folder    
- Then `vagrant up`

### Other notes
- I used this machine to create the GCP environment setup scripts (under the `travis/` directory)
- I also used it to encrypt the project key needed by Travis 
- After I started to build on Travis I stopped updating the scripts because all the work was done on the app repo
- Also I delete environments from here (I don't have a solution for env cleanup yet)
