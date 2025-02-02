//modify the element returned in the tumor channel to have the key:value pair type:
//'abnormal' instead of type:'tumor'


branch { meta, reads ->
    tumor: meta.type == "tumor"
        return [meta + [type: 'abnormal'], reads]
    normal: true
}