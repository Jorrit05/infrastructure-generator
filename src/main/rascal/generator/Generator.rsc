module generator::Generator

import IO;
import genLib::Core;
import lzaasDefaults::LzaasDevDefaults;
import Exception;

// Combine the current resource with it defaults, if these are there.
private tuple[str, map[str,value]] addDefaults(map[str,value] original) {

    // Remove the type key to prevent it from being written to config.
    <rType, resourceMap> = deleteKey("type", original);
    map[str,value] final = ();

    try
        final = defaultMap[rType] + resourceMap;
    catch NoSuchKey(str msg):
        final = resourceMap;

    return <rType, final>;
}

// Generate function, generates terreform config based on a list of maps.
public void generate(loc target_folder, list[map[str,value]] infrastructure) {

    for (resource <- [f | f <- infrastructure]) {
        loc folder = target_folder;

        <rType, final> = addDefaults(resource);

        str terraform =
        "resource <transform(rType)> <transform(final["name"])> {
        '  <for (key <- [f | f <- final]) {>
        '  <transform(<key,final[key]>)><}>
        '}
        '
        '";

        // Create file name based on current type and append to file
        loc target = createTargetLoc(target_folder, rType);
        appendToFile(target, terraform);
    };
}
