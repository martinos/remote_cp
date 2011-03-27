# RemoteCp [![](http://stillmaintained.com/martinos/remote_cp.png)](http://stillmaintained.com/martinos/remote_cp)
</a>
## Description
RemoteCp is a command line tool intended to facilitate copying files accross the internet. You need to install the gem on both source and destination computers. Since it uses Amason S3, you need to create a S3 Bucket and configure the source and destination computer with the bucket keys.
##Installation
Install the gem

    $ gem install remote_cp

Setup your remote cp by editing ~/.remote_cp.yml config file:

    :access_key_id: MY_ACCESS_KEY
    :secret_access_key: MY_SECRET
    :bucket_name: MY_BUCKET_NAME
##Usage
To copy a file to the remote clipboard:

    machineA: rt cp filename
The file can be pasted on another machine if remote_cp gem has been installed with the same bucket credentials.

    machineB: rt p
You can also copy directories

    machineA: rt cp dirname
To paste the file in the current directory

    machineB: /home/tata>$ rt p
    machineB: /home/tata>$ ls -d */
    /dirname
You can copy stdin to the remote clipboard:

    machineA: ls -l | rt cp
You can also dump the remote clipboard to the stdout.

    machineB: rt cat
    total 8
    drwxr-xr-x   5 martinos  staff   170 25 Mar 23:08 .
    drwxr-xr-x  10 martinos  staff   340 25 Mar 23:08 log
    drwxr-xr-x   2 martinos  staff    68 25 Mar 23:08 a_dir
    -rw-r--r--   1 martinos  staff    15 25 Mar 23:07 a_file.txt
    drwxr-xr-x  65 martinos  staff  2210 25 Mar 23:07 ..
## License

Released under the MIT License.  See the LICENSE file for further details.




