FROM ubuntu:18.04

RUN apt-get update -qq  \
    && apt-get install -y -qq g++ \
    && apt-get install -y -qq bison \
    && apt-get install -y -qq flex 

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

CMD bison -d calc.y && flex calc.l && g++ -w -o calc calc.tab.c lex.yy.c -lfl && ./calc