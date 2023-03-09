#!/bin/bash
prog=$0

function usage {
    cat <<HELP_USAGE
    Usage: $prog [-hr] [-c address] [-n filename]
        -h               Display help options
        -r               Delete existing certificates PERMANENTLY before 
                         performing other actions

        -c address       CN for the certificate. Default is 'localhost'
        -n filename      Name of the certificates and keys
        -p password      Password of the certificates
HELP_USAGE
}

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

# Move to the project root
cd ../ || exit

# Define variables
address="localhost"
filename=""
password=""
remove_certs=0

while [[ $# -gt 0 ]]
do
    opt="$1";
    shift;
    case "$opt" in
        "-h")
            usage
            exit 1
            ;;
        "-r")
            remove_certs=1
            ;;
        "-c")
            address=$1
            shift
            ;;
        "-n")
            filename=$1
            shift
            ;;
        "-p")
            password=$1
            shift
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$filename" || -z "$password" ]]; then
    usage
    exit 1
fi

if [[ $remove_certs -eq 1 ]]; then
    echo "Removing existing certificates..."
    rm -f certs/*
fi

# Move into the certs directory
cd certs/ || exit

echo "Generating $filename.req"
openssl req -new -text -passout pass:"$password" -subj /CN="$address" -out "$filename".req

echo "Generating $filename.key"
openssl rsa -in privkey.pem -passin pass:"$password" -out "$filename".key

echo "Generating $filename.crt"
openssl req -x509 -in "$filename".req -text -key "$filename".key -out "$filename".crt

# TODO add permission fix?