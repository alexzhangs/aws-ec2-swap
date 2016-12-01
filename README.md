# aws-ec2-swap

Setup swap file on AWS EC2 instance

## Installation

```
git clone https://github.com/alexzhangs/aws-ec2-swap
```

## Usage

Setup an 1GB swap file.

```
sh aws-ec2-swap/aws-ec2-swap.sh -s 1024
```

Re-setup the existing swap file, increase size to 2GB.

```
sh aws-ec2-swap/aws-ec2-swap.sh -s 2048 -f
```

The swap file is located at: `/var/swap.1`

## Helpful command

List loaded swap files.

```
/sbin/swapon
```
