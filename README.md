# ASHO-101
This is the starting repository for the Aerospike Hands On 101 Course

To get started:

1. Clone the repository
    ``` bash
    git clone https://github.com/citrusleaf/aerospike-education.git
    ```
2. From of the root of `aerospike-education` run
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
