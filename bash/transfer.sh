#!/bin/bash

zip EP-setB1001_FASTQ.zip EP-setB1001_FASTQ/*
aws s3 cp EP-setB1001_FASTQ.zip s3://dpath

zip EP-setB2001_FASTQ.zip EP-setB2001_FASTQ/*
aws s3 cp EP-setB2001_FASTQ.zip s3://dpath

zip IDP-setA_FASTQ.zip IDP-setA_FASTQ/*
aws s3 cp IDP-setA_FASTQ.zip s3://dpath

zip IDP-setC_FASTQ.zip IDP-setC_FASTQ/*
aws s3 cp IDP-setC_FASTQ.zip s3://dpath
