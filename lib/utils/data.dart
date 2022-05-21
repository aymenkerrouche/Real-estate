// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoire/Services/user.dart';

var logo = "logo.png";
var profile = {
  "name" : "user",
  "image" : "https://img.icons8.com/fluency/240/000000/user-male-circle.png",
  "email" : "",
};
int usertype = 2;
User? user;


List categories = [
  {
    "name" : "All",
    "icon" :  FontAwesomeIcons.boxes
  },
  {
    "name" : "Villa",
    "icon" :  FontAwesomeIcons.university
  },
  {
    "name" : "House",
    "icon" :  FontAwesomeIcons.home
  },
  {
    "name" : "Shop",
    "icon" :  FontAwesomeIcons.storeAlt
  },
  {
    "name" : "Building",
    "icon" :  FontAwesomeIcons.building
  },
];


List filter = [
  {
    "name" : "Prix",
  },
  {
    "name" : "Type de logement",
  },
  {
    "name" : "Equipements",
  },
  {
    "name" : "Localisation",
  },
  {
    "name" : "Agence",
  },
];


List populars = [
  {
    "image": "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "name": "Twin Castle",
    "price": "\$ 175k",
    "location": "Oran, Algeria",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Single Villa",
    "price": "\$ 280k",
    "location": "Alger, Algeria",
    "is_favorited": true,
  },
  {
    "image": "https://images.unsplash.com/photo-1598928506311-c55ded91a20c?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Convertible Studio",
    "price": "\$ 150k",
    "location": "Constantine, Algeria",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1580494767366-82f4e74f5655?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "name": "Twin Villa",
    "price": "\$ 120k",
    "location": "Skikda, Algeria",
    "is_favorited": false,
  },
];

List wilaya = [
  {
    "image": "https://images.unsplash.com/photo-1575664274476-e02d99195164?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1931&q=80",
    "name": "Alger",
  },
  {
    "image": "https://i.pinimg.com/564x/17/26/17/1726178b8b9585cae3a7175b6cfb8222.jpg",
    "name": "Constantine",
  },
  {
    "image": "https://i.pinimg.com/564x/71/ee/33/71ee33b80632aa4ee5e2debd77b252aa.jpg",
    "name": "Oran",
  },
];

List recents = [
  {
    "image": "https://images.unsplash.com/photo-1571939228382-b2f2b585ce15?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Alger",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1560185007-5f0bb1866cab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "name": "Convertible Studio",
    "price": "\$150k",
    "location": "Constantine",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1576941089067-2de3c901e126?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Oran",
    "is_favorited": false,
  },
];


var brokers = [
    {
    "image": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjV8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60", 
    "name": "John Siphron", 
    "type": "Broker", 
    "description": "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4, 
  },
  {
    "image":"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name" : "Corey Aminoff",
    "type": "Broker", 
    "description": "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4, 
  },
  {
    "image" : "https://images.unsplash.com/photo-1617069470302-9b5592c80f66?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Siriya Aminoff", 
    "type": "Broker", 
    "description": "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4, 
  },
  {
    "image" : "https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Rubin Joe", 
    "type": "Broker", 
    "description": "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4, 
  },
];

List companies = [
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "TS Home",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": false,
    "icon" : Icons.domain_rounded
  },
  {
    "image": "https://images.unsplash.com/photo-1618221469555-7f3ad97540d6?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Century 21",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon" : Icons.house_siding_rounded
  },
  {
    "image": "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Dabest Pro",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon" : Icons.home_work_rounded
  },
  {
    "image": "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Cam Reality",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon" : Icons.location_city_rounded
  },
];

List favorites = [
  {
    "image": "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "name": "Twin Castle",
    "price": "\$ 175k",
    "location": "Oran, Algeria",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Single Villa",
    "price": "\$ 280k",
    "location": "Alger, Algeria",
    "is_favorited": true,
  },
  {
    "image": "https://images.unsplash.com/photo-1598928506311-c55ded91a20c?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Convertible Studio",
    "price": "\$ 150k",
    "location": "Constantine, Algeria",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1580494767366-82f4e74f5655?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "name": "Twin Villa",
    "price": "\$ 120k",
    "location": "Skikda, Algeria",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Constantine",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1598928506311-c55ded91a20c?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Convertible Studio",
    "price": "\$150k",
    "location": "Alger",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1576941089067-2de3c901e126?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Oran",
    "is_favorited": false,
  },

  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Jijel",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Skikda",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Annaba",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Stif",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Phnom Penh",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Phnom Penh",
    "is_favorited": false,
  },
  {
    "image": "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Double Villa",
    "price": "\$180k",
    "location": "Phnom Penh",
    "is_favorited": false,
  },
];

const List logement = [
  {
    "type": 'Apparetemnt',
    "img": 'https://images.unsplash.com/photo-1455587734955-081b22074882?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1920&q=80',
  },
  <String, dynamic>{
    'type': 'Villa',
    'img': 'https://images.unsplash.com/photo-1602343168117-bb8ffe3e2e9f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1925&q=80',
  },
  <String, dynamic>{
    'type': 'Duplex',
    'img': 'https://images.unsplash.com/photo-1590725175785-de025cc60835?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1887&q=80',
  },
  <String, dynamic>{
    'type': 'Studio',
    'img': 'https://images.unsplash.com/photo-1632800617933-712949cc4d42?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1935&q=80',
  },
];

List images = [
  {
    "image" : "https://images.unsplash.com/photo-1632800617933-712949cc4d42?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1935&q=80",
  },
  {
    "image" : "https://images.unsplash.com/photo-1590725175785-de025cc60835?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1887&q=80",
  },
  {
    "image" : "https://images.unsplash.com/photo-1602343168117-bb8ffe3e2e9f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1925&q=80",
  },
  {
    "image" : "https://images.unsplash.com/photo-1455587734955-081b22074882?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1920&q=80",
  },
];



List equipements = [
  {
    "name" : "Bed",
    "icon" :  FontAwesomeIcons.bed,
  },
  {
    "name" : "Bath",
    "icon" :  FontAwesomeIcons.bath
  },
  {
    "name" : "Wifi",
    "icon" :  FontAwesomeIcons.wifi
  },
  {
    "name" : "Water",
    "icon" :  FontAwesomeIcons.faucet
  },
  {
    "name" : "Gaz",
    "icon" :  FontAwesomeIcons.fire
  },
  {
    "name" : "Clim",
    "icon" :  FontAwesomeIcons.snowflake
  },
  {
    "name" : "TV",
    "icon" :  FontAwesomeIcons.tv
  },
  {
    "name" : "Pool",
    "icon" :  FontAwesomeIcons.swimmingPool
  },
  {
    "name" : "Building",
    "icon" :  FontAwesomeIcons.building
  },
];