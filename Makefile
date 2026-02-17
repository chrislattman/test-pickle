java:
	java TestPickle.java

python:
	python3 testpickle.py

nodejs:
	node testpickle.js

go:
	go run go/testpickle.go

rust:
	cargo run -q

cpp:
	g++ -o testpickle testpickle.cpp -lboost_serialization && ./testpickle

.PHONY: java python nodejs go rust cpp
