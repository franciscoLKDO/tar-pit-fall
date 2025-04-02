# CTF Challenge: Privilege Escalation via Directory Traversal

## Introduction
This CTF challenge demonstrates a privilege escalation vulnerability caused by insecure handling of tarball extraction. The target application fails to properly validate extracted file paths, allowing attackers to overwrite critical system files.

## Challenge Details
- **Category:** Privilege Escalation, Directory Traversal
- **Difficulty:** Easy/Medium
- **Objective:** Gain root access by exploiting the application’s insecure tarball extraction.

## Scenario
An enthusiastic developer has created an interactive CLI tool to help users easily read and extract tar archives. Wanting to share his creation with the world, he releases the application without realizing a critical flaw: it does not properly sanitize extracted file paths. This oversight allows attackers to craft malicious tarballs that escape the intended extraction directory, leading to potential privilege escalation.

## Setup
### Requirements
- Docker (recommended) or a Linux system
- Basic knowledge of tarball structures and file permissions

### Quick Run 

```sh 
docker run --name ctf -d -p 2222:22 franciscolkdo/tar-pit-fall
ssh Tom@localhost -p 2222
# password tarpit
```

### Installation
If you want to build the challenge yourself
1. Clone the repository:
```sh
git clone https://github.com/franciscoLKDO/tar-pit-fall.git
cd ctf-challenge
```
2. Build and run the challenge using Docker:
```sh
docker build -t ctf-tarball . --build-arg USER=${YOUR_USER} --build-arg USER_PASSWORD=${YOUR_USER_PASSWORD} --build-arg FLAG=${YOUR_FLAG}
docker run -p 2222:22 -d ctf-tarball
```
3. Connect to the instance:
```sh
ssh ${YOUR_USER}@localhost -p 2222
# Use ${YOUR_USER_PASSWORD} to connect to the container
```

## Exploitation
- Analyze how the application extracts tarballs.
- Craft a malicious `.tar` file containing a payload with `../` sequences.
- Upload and extract the archive to overwrite sensitive files.
- Escalate privileges and gain root access.

## Flags
- Flag is stored in `/root/flag.txt`.

## Hints
- Look for unsafe extraction practices.
- Everything is relative
- Consider how files might be overwritten.
- Could be great to be root on ssh login

## Disclaimer
This challenge is for educational purposes only. Do not attempt similar attacks on real-world systems without authorization.

## License
Apache License Version 2.0. See [LICENSE](./LICENSE) for details.
