# Check relnet for generalization.
using JSON
function getcolors(data)
    color    = Dict()
    shape    = Dict()
    material = Dict()
    color_shape = Dict()
    color_material = Dict()
    shape_material = Dict()
    color_shape_material = Dict()

    for scene in data
        for obj in scene["objects"]
            g1 = obj["color"]
            g2 = obj["shape"]
            g3 = obj["material"]
            get!(color,g1,length(color)+1)
            get!(shape,g2,length(shape)+1)
            get!(material,g3,length(material)+1)
            get!(color_shape,string(g1,"_",g2),length(color_shape)+1)
            get!(color_material,string(g1,"_",g3),length(color_material)+1)
            get!(shape_material,string(g2,"_",g3),length(shape_material)+1)
            get!(color_shape_material,string(g1,"_",g2,"_",g3),length(color_shape_material)+1)
        end
    end
    return color,shape,material,color_shape,color_material,shape_material,color_shape_material
end

function exclude_pair(question,p1,p2)
    subset = Any[]
    deleted = Any[]
    for i=1:length(question)
        q = question[i]
        tokens = q["processed_tokens"]
        if (p1 in tokens) && (p2 in tokens)
            push!(deleted,q)
        else
            push!(subset,q)
        end
    end
    return subset,deleted
end

splitname="train"
filename = string("/KUFS/scratch/edayanik16/other/relnet-example/data/CLEVR_v1.0/scenes/CLEVR_",splitname,"_scenes.json")
question_filename=string("/KUFS/scratch/edayanik16/other/relnet-example/data/processed/",splitname,"_processed.json")

data     = JSON.parsefile(filename)["scenes"]
question = JSON.parsefile(question_filename)
color,shape,material,color_shape,color_material,shape_material,color_shape_material = getcolors(data)
subset,deleted = exclude_pair(question,"red","sphere")
js_subset  = JSON.json(subset)
js_deleted = JSON.json(deleted)


open(string(split(question_filename,".")[1],"_subset.json"),"w") do fout
    write(fout,js_subset)
end

open(string(split(question_filename,".")[1],"_deleted.json"),"w") do fout
    write(fout,js_deleted)
end



# train ve dev'den bir tane color_shape'i cikarayim. bunu hic gormesin. (tabi train size'i minimum etkileyecek seviyede cikarayim)
# sonra train edeyim sonra da cikardigim pair ile test edeyim. Bunu nasil yapacagim ?
