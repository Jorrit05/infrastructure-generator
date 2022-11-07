module genLib::Core

import genLib::Types;
import genLib::Data;

import IO;
import Map;
import String;

// Make a string representation of a list and add quotes to each string.
public str parseListOfString(list[str] lst) {
    str S = "[";
    for( item <- lst){
        S = S + "\"<item>\",";
    }
    S = S[..-1]  + "]";
    return S;
}

// Make a string representation of a list.
public str parseDependencyList(list[str] lst) {
    str S = "[";
    for( ip <- lst){
        S = S + "<ip>,";
    }
    S = S[..-1]  + "]";
    return S;
}

// General function to remove a key from a map.
// Return the map and the key
public tuple[str, map[str,value]] deleteKey(str key, map[str,value] myMap) {
    str val = transform(myMap[key]);
    newMap = delete(myMap, key);
    return <val, newMap>;
}

// Create string representation a Terraform block structure
public str parseBlock(map[str,value] block) {
    str name = transform(block["block_name"]);
    name = replaceAll(name, "\"", "");
    block = delete(block, "block_name");

    return
    "<name> {<for (key <- [f | f <- block]) {>
    '  <transform(<key,block[key]>)><}>
    '}
    ";
}

// Several transformation functions to create correct terraform
// based on the terraform pattern (block, map, string, int)
public str transform(<str key, int n>) =  "<key> = <n>";
public str transform(<str key,list[str] names>) =  "<key> = <parseListOfString(names)>";
public str transform(<_, map[str, value] block>) = parseBlock(block);
public str transform(<str key,str name>) = "<key> = \"<name>\"";
public str transform(<key, dependency(str dependency)>) = "<key> = <dependency>";
public str transform(<key, dependencyList(list[str] dependency)>) = "<key> = <parseDependencyList(dependency)>";

public str transform(str name) = "\"<name>\"";
public str transform(list[str] names) = parseListOfString(names);
public str transform(resourceType(str rType)) = rType;

public str removeUntilFirstUnderscore(str S) {
    // Could maybe be done better?
    // Finds everything from start to string to and including the next underscore.
    // It will do this recursively, hence the break.
    while(/[^_]_+<rest:.*$>/ := S){
        S = rest;
        break;
    };
    return S;
}

// Create .tf file from a string and target location
public loc createTargetLoc (loc target, str resourceName){
    str rType = removeUntilFirstUnderscore(resourceName);
    target += rType + ".tf";
    return target;
}

// Create and/or empty all output files.
public void init(loc target_folder, list[map[str,value]] infrastructure){
    set[str] setOfTypes = {};

    for (resource <- [f | f <- infrastructure]) {
        str rType = transform(resource["type"]);
        setOfTypes += rType;
    };

    for (resource <- [f | f <- setOfTypes]) {
        loc target = createTargetLoc(target_folder, resource);
        touch(target);
        writeFile(target, "");
    };
}

public list[map[str, value]] transformMultipleResources(map[Resources, set[str]] names, str rgName) {
    list[map[str, value]] retVal = [];

    for (resource <- [f | f <- names]) {
        for (val <- [f | f <- names[resource]]) {
            map[str, value] tmp = (
                "type" : resource,
                "resource_group_name" : rgName,
                "name" : val
            );
            retVal += tmp;
        };
    };
    return retVal;
}


public void main() {
    println(storage_account);
}