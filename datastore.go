package main

import (
	"fmt"
	"strconv"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

const availabilityZoneName = "us-east-1"

func retreiveShrines() []Shrine {
	svc := dynamodb.New(session.New(&aws.Config{Region: aws.String(availabilityZoneName)}))

	scanInput := &dynamodb.ScanInput{
		TableName: aws.String("Shrines"),
	}

	scan, err := svc.Scan(scanInput)
	if err != nil {
		fmt.Println("Unable to scan database.", err)
		return nil
	}

	shrines := []Shrine{}
	err = dynamodbattribute.UnmarshalListOfMaps(scan.Items, &shrines)
	if err != nil {
		fmt.Println("Unable to parse database items.", err)
		return nil
	}

	return shrines
}

func storeLocationQuery(locationQuery LocationQuery) {
	svc := dynamodb.New(session.New(&aws.Config{Region: aws.String(availabilityZoneName)}))

	writeInput := &dynamodb.BatchWriteItemInput{
		RequestItems: map[string][]*dynamodb.WriteRequest{
			"TreasureHunt": {
				&dynamodb.WriteRequest{
					PutRequest: &dynamodb.PutRequest{
						Item: map[string]*dynamodb.AttributeValue{
							"UserID": {
								S: aws.String(locationQuery.UserID),
							},
							"Timestamp": {
								N: aws.String(strconv.FormatInt(locationQuery.Timestamp, 10)),
							},
							"Latitude": {
								N: aws.String(strconv.FormatFloat(locationQuery.Latitude, 'f', -1, 64)),
							},
							"Longitude": {
								N: aws.String(strconv.FormatFloat(locationQuery.Longitude, 'f', -1, 64)),
							},
						},
					},
				},
			},
		},
	}

	_, err := svc.BatchWriteItem(writeInput)
	if err != nil {
		fmt.Println("Unable to properly write to database.", err)
		return
	}
}
