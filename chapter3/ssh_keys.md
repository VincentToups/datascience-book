Secure Shell
============

"ssh" stands for secure shell. We've talked about _terminals_ aplenty, or
at least seen a few. A problem we might need to solve is how to securely
connect two computers over the internet so that you can execute commands 
on one of them from somewhere else.

Secure shell handles this problem. The server machine runs a server, and the
client connects to it (`ssh <some-server>`) and then an authentication happens
and the two computers can exchange data or you can run commands on the remote
machine.

Git supports using ssh as a transport protocol for git data. To use that feature
with GitHub, which is the recommended way, we need to have an ssh key pair. 
This is a cryptographic thingy with the following basic properties: 

1. it's two numbers
2. if I have the private number and you have the public number you can verify
that I have the private number even though you can't see the private number.

We generate one with ssh-keygen.

:student-select:Suppose we wanted to know what the ssh-keygen command does? How would we figure that out?, ../students.json::.
```bash 
cd ~/.ssh/
ssh-keygen

```
Note that we now have two files, the public and the private one. 

We can share the public one with whomever we want! The private one we must never
share and never put in our git repo. Anyone who has the private key can pretend
to be us.

:student-select:invent a question, ../students.json::.

We visit GitHub, go to our settings, add our public key, and then we can follow
the rest of the instructions, which are like this:

``` 
ssh-agent bash
ssh-add ~/.ssh/id_rsa 
git add remote origin <git ssh style url>
git push -u origin main
```
Now we can get to work on our actual data science.

Starting with our ::data:data::. 
