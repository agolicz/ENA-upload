import sys

for l in open(sys.argv[1]):
    if(l.startswith("#")):
        print(l.rstrip())
        continue
    l_arr=l.rstrip().split("\t")
    if(l_arr[2]=="gene"):
        gid=l_arr[8].split("=")[1]
        gn=gid
        if(l_arr[0]=="chr1S" or l_arr[0]=="chr1L"):
            gn=gid.replace("Vfaba.Hedin2.R1.1g","VFH_I")
        elif(l_arr[0]=="chr2"):
            gn=gid.replace("Vfaba.Hedin2.R1.2g","VFH_II")
        elif(l_arr[0]=="chr3"):
            gn=gid.replace("Vfaba.Hedin2.R1.3g","VFH_III")
        elif(l_arr[0]=="chr4"):
            gn=gid.replace("Vfaba.Hedin2.R1.4g","VFH_IV")
        elif(l_arr[0]=="chr5"):
            gn=gid.replace("Vfaba.Hedin2.R1.5g","VFH_V")
        elif(l_arr[0]=="chr6"):
            gn=gid.replace("Vfaba.Hedin2.R1.6g","VFH_VI")
        else:
            gn=gid.replace("Vfaba.Hedin2.R1.Ung","VFH_U")
        print(l.rstrip()+";Name="+gn)
    else:
        print(l.rstrip())
