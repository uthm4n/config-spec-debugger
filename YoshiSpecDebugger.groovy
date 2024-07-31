package com.morpheus 

import groovy.json.*
import groovy.json.JsonOutput

def findKeys(String searchKey, Map spec, Map foundKeys = [:]) {
    spec.each { key, value ->
        if (key.toLowerCase().contains(searchKey.toLowerCase())) {
            foundKeys[key] = value
        }
        if (value instanceof Map) {
            findKeys(searchKey, value, foundKeys)
        } else if (value instanceof List) {
            value.each { item ->
                if (item instanceof Map) {
                    findKeys(searchKey, item, foundKeys)
                }
            }
        }
    }
    return foundKeys
}

def searchKey = "hostname"                     // searching for all keys in the config spec that have "hostname" in any part of the key's name
def result = findKeys(searchKey, spec)
def matches = JsonOutput.prettyPrint(JsonOutput.toJson(result))

println """
    =================== CONFIG SPEC =========================

    \t${spec}

    """

try {
	println """
    =================== SPEC MATCHES FOR ${searchKey} ===================
    
    \t${matches}
    
    """
} catch (Exception e) {
	println "Key not found in spec"
    println "${e}"
    println "${e.printStackTrace()}"
}

// and then proceed with update e.g. to update hostname in the spec:
// 
// def hostNameOverride = "ueqbal"
// spec.hostName = hostNameOverride          (wrap in a try-catch in the final code)
//
