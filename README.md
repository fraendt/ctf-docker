# ctf-docker
A dockerfile for everything ctf

### Running

 - To build just run `docker build . -t ctf`.   
 - To run the image, run `docker run -itd --name ctf -p 25900:5900 -p 25901:5901 ctf`
 - Finally, to open the image, run `docker exec -it ctf /bin/zsh`.
 - To run with a desktop you can open up a vnc screen share and connect to
`127.0.0.1:25900`.
