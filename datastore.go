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

type wsMessage struct {
	Username  string
	Timestamp int64
	Message   string
}

type shrine struct {
	ShrineID     string
	Latitude     float64 `json:"Latitude,string"`
	Longitude    float64 `json:"Longitude,string"`
	ShrineNumber int
	ShrineType   int
}

type shrineCheck struct {
	UserID    string
	Timestamp int64
	Latitude  float64 `json:"Latitude,string"`
	Longitude float64 `json:"Longitude,string"`
}

func storeMessage(message wsMessage) {
	svc := dynamodb.New(session.New(&aws.Config{Region: aws.String(availabilityZoneName)}))

	writeInput := &dynamodb.BatchWriteItemInput{
		RequestItems: map[string][]*dynamodb.WriteRequest{
			"GoChat": {
				&dynamodb.WriteRequest{
					PutRequest: &dynamodb.PutRequest{
						Item: map[string]*dynamodb.AttributeValue{
							"Username": {
								S: aws.String(message.Username),
							},
							"Timestamp": {
								N: aws.String(strconv.FormatInt(message.Timestamp, 10)),
							},
							"Message": {
								S: aws.String(message.Message),
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

func retreiveMessages() []wsMessage {
	svc := dynamodb.New(session.New(&aws.Config{Region: aws.String(availabilityZoneName)}))

	scanInput := &dynamodb.ScanInput{
		TableName: aws.String("GoChat"),
	}

	scan, err := svc.Scan(scanInput)
	if err != nil {
		fmt.Println("Unable to scan database.", err)
		return nil
	}

	messages := []wsMessage{} // notice db schema matches messages format, convention over configuration
	err = dynamodbattribute.UnmarshalListOfMaps(scan.Items, &messages)
	if err != nil {
		fmt.Println("Unable to parse database items.", err)
		return nil
	}

	return messages
}

func retreiveShrines() []shrine {
	svc := dynamodb.New(session.New(&aws.Config{Region: aws.String(availabilityZoneName)}))

	scanInput := &dynamodb.ScanInput{
		TableName: aws.String("Shrines"),
	}

	scan, err := svc.Scan(scanInput)
	if err != nil {
		fmt.Println("Unable to scan database.", err)
		return nil
	}

	shrines := []shrine{}
	err = dynamodbattribute.UnmarshalListOfMaps(scan.Items, &shrines)
	if err != nil {
		fmt.Println("Unable to parse database items.", err)
		return nil
	}

	return shrines
}

func storeShrineCheck(shrineCheck shrineCheck) {
	svc := dynamodb.New(session.New(&aws.Config{Region: aws.String(availabilityZoneName)}))

	writeInput := &dynamodb.BatchWriteItemInput{
		RequestItems: map[string][]*dynamodb.WriteRequest{
			"TreasureHunt": {
				&dynamodb.WriteRequest{
					PutRequest: &dynamodb.PutRequest{
						Item: map[string]*dynamodb.AttributeValue{
							"UserID": {
								S: aws.String(shrineCheck.UserID),
							},
							"Timestamp": {
								N: aws.String(strconv.FormatInt(shrineCheck.Timestamp, 10)),
							},
							"Latitude": {
								N: aws.String(strconv.FormatFloat(shrineCheck.Latitude, 'f', -1, 64)),
							},
							"Longitude": {
								N: aws.String(strconv.FormatFloat(shrineCheck.Longitude, 'f', -1, 64)),
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
