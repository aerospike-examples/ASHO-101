# ASHO-101
This is the starting repository for the Aerospike Hands On 101 Course

To get started:

1. GET A COPY OF THIS CODE BASE. 
   *a) For new developers:
       Locate the green button that says [<> Code v] and go to the bottom option Download Zip.
       Once the file is downloaded, unzip it (you can unzip it on your Desktop if that makes sense for you)
   *b) For Advanced Users: Clone the repository:
    ``` bash
    git clone https://github.com/citrusleaf/aerospike-education.git
    ```
2. OPEN DOCKER AND BUILD THE IMAGE.
    *a) For new developers:
       Open a terminal in Docker Desktop and run an ls command. Run cd and ls commands until you are in the same folder as the docker file you just downloaded as part of this project.
       Once you've navigated to the Dockerfile location you need to run a docker build command. To run the command you need to know whether your machine is AMD or ARM. Do a google search to try to figure this out. 
       When you know whether your machine's processor is AMD or ARM you can run the docker build command below. 
    *b) For Advanced develoers:
       From of the root of `aerospike-education` run
        ``` bash
        # For --platform:
        # Use linux/arm64 for Apple silicon and other arm based machines
        # Use linux/amd64 for Intel/AMD based machines

        docker build -t aerospike-education . --platform linux/arm64
        ```
3. After the container has been created, run
    ``` bash
    docker run -d --name aerospike-education -p 8080-8081:8080-8081 aerospike-education
    ```
4. Open your browser to http://localhost:8080 to browse the VestVault website.
   Open your browser to http://localhost:8081 to access VS Code. 
