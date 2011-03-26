# RemoteCp
<a href="http://stillmaintained.com/martinos/remote_cp">
<img src="http://stillmaintained.com/martinos/remote_cp.png" />
</a>
## Description
RemoteCp is a command line tool intended facilitate copying files accross the internet. You need to install the gem on both source and destination systems. Since it uses Amason S3, you need to create a S3 Bucket and configure the source and destination computer with the bucket keys.
##Installation
Install the gem

    $ gem install remote_cp

Add the Amazon access and private key of your S3 bucket in your .bashrc file:

    export AMAZON_ACCESS_KEY_ID='MYACCESSKEY'
    export AMAZON_SECRET_ACCESS_KEY='SECRET ACCESS KEY'
##Usage
To copy a file to the remote clipboard:
    <machineA>$ rt cp filename
The file can be pasted on another machine if remote_cp gem has been installed with the same bucket credentials.

    <machineB>$ rt cp
You can also copy directories

    <machine A>$ rt cp dirname
To paste the file in the current directory

    <machineB:/home/tata>$ rt p
    <machineB:/home/tata>$ ls -d */
    /dirname
You can copy stdin to the remote clipboard:

    <machineA> ls -l | rt cp
You can also dump the remote clipboard to the stdout.

    <machineB> rt cat
    total 8
    drwxr-xr-x   5 martinchabot  staff   170 25 Mar 23:08 .
    drwxr-xr-x  10 martinchabot  staff   340 25 Mar 23:08 clog
    drwxr-xr-x   2 martinchabot  staff    68 25 Mar 23:08 a_dir
    -rw-r--r--   1 martinchabot  staff    15 25 Mar 23:07 a_file.txt
    drwxr-xr-x  65 martinchabot  staff  2210 25 Mar 23:07 ..




