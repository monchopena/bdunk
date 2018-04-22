Date: 30 Nov 2012
Categories: development
Summary: When you work with many serves yo can get crazy about Where am I?
Read more: Show me more

# How to change prompt colour and motd

When you work (hard) with many servers on terminal you need to distinguish them. The best way is.

## Set the prompt

Add line to .bashrc:

	export PS1="\e[1;36m\u@\h-super-dev-\w# \e[m"

Don't forget reload file:

	source .bashrc

Ok there are lots of colours.

![bashcolor]

A list:

	Black       0;30     Dark Gray     1;30
	Blue        0;34     Light Blue    1;34
	Green       0;32     Light Green   1;32
	Cyan        0;36     Light Cyan    1;36
	Red         0;31     Light Red     1;31
	Purple      0;35     Light Purple  1;35
	Brown       0;33     Yellow        1;33
	Light Gray  0;37     White         1;37

## Changing the motd file

When you start system you can change initial message in /etc/motd. *Mental note*: Don't forget make a copy when you change it.

And add colour to your live! Simple sample motd:

	[moncho@bdunk.com]$ echo -en "\033[1;34m" > /etc/motd
	[moncho@bdunk.com]$ echo "Text of your motd file....." >> /etc/motd
	[moncho@bdunk.com]$ echo -en "\033[0m" >> /etc/motd

You can add funny ASCII Artwors:

![motd_star_wars]


[motd_star_wars]: /attachments/motd_star_wars.png "/etc/motd starwars sample"
[bashcolor]: /attachments/bashcolor.png "Bash Colour"