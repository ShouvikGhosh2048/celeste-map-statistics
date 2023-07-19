import XLSX, HTTP, JSON3, Downloads, ZipFile

modlist = XLSX.readxlsx("Celeste Mods List.xlsx")

if !isdir("Mods")
    mkdir("Mods")
end

REQUESTLIMIT = 250
URLCOLUMN = "M"

requests = 0
requestedmorethanlimit = false

for sheet = 3:7
    println(modlist[sheet].name)
    if requestedmorethanlimit
        break
    end
    for row in XLSX.eachrow(modlist[sheet])
        url = row[URLCOLUMN]
        if url !== missing
            id = match(r"^https://gamebanana.com/mods/([0-9]+)$", url)
            if id !== nothing
                id = id.captures[1]
                modpath = joinpath("Mods", id)
                # Mod is already downloaded so we don't need to download it.
                if isdir(modpath)
                    continue
                end

                if requests >= REQUESTLIMIT
                    global requestedmorethanlimit = true
                    break
                end

                # Get the information about files from GameBanana's API.
                response = HTTP.get(
                    "https://api.gamebanana.com/Core/Item/Data";
                    query=[
                        "itemtype" => "Mod",
                        "itemid" => id,
                        "fields" => "Files().aFiles()"
                    ]
                )
                global requests += 1
                files = JSON3.read(String(response.body))
                # If the mod doesn't exist, the API returns an error JSON object.
                # If it exists, we get a JSON array.
                if !(files isa JSON3.Array) || length(files) == 0 || files[1] === nothing
                    continue
                end
                files = files[1]

                latest = nothing
                for (_, file) in files
                    if latest === nothing || latest[2] < file["_tsDateAdded"]
                        latest = (file, file["_tsDateAdded"])
                    end
                end
                (file, _) = latest

                zipfilepath = joinpath("Mods", file["_sFile"])
                println(string("Downloading ", file["_sFile"]))

                downloaded = false
                for i = 1:3
                    try
                        Downloads.download(file["_sDownloadUrl"], zipfilepath)
                        downloaded = true
                        break
                    catch
                        if i < 3
                            println("Download failed - retrying")
                        end
                    end
                end
                if !downloaded
                    println("Couldn't download ", file["_sFile"])
                    continue
                end

                println(string("Downloaded ", file["_sFile"]))

                # Modified version of unzip from
                # https://discourse.julialang.org/t/how-to-extract-a-file-in-a-zip-archive-without-using-os-specific-tools/34585/5
                # We extract the .bin files in the Maps folder from the zip file and then delete the zip file.
                zipfilepath = joinpath(pwd(), zipfilepath)
                modpath = joinpath(pwd(), modpath)
                mkdir(modpath)

                zipfile = nothing
                try
                    # ZipFile.Reader may throw an error due to https://github.com/fhs/ZipFile.jl/issues/73
                    zipfile = ZipFile.Reader(zipfilepath)
                catch
                    println("Could not read the zip file.")
                    continue
                end
                for f in zipfile.files
                    # We just copy the .bin files in Maps folder.
                    if startswith(f.name, "Maps") && endswith(f.name, ".bin")
                        filepath = joinpath(modpath, f.name)
                        mkpath(dirname(filepath))
                        write(filepath, read(f))
                    end
                end
                close(zipfile)

                rm(zipfilepath)
            end
        end
    end
end

if requestedmorethanlimit
    println("API limit reached. Try again after an hour.")
else
    println("Download completed.")
end