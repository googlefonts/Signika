#MenuTitle: Match Metrics
# -*- coding: utf-8 -*-
__doc__="""
Matches metrics from one master to another
"""
####################################
############# set vars ############# 

masterToEdit = "Light-GRAD"
masterToCopy = "Light"

printNewValues = False

setNewValues = True

############# set vars ############# 
####################################

font = Glyphs.font

# get layer IDs for masters
for master in font.masters:

    if master.name == masterToEdit:
        masterToEditID = master.id
    if master.name == masterToCopy:
        masterToCopyID = master.id
    ## TODO? catch errors to make this more flexible
    # while True:
    #     try:
    #         print(masterToEdit, masterToCopy)
    #         break
    #     except SyntaxError:
    #         print("be sure to set the vars in this script to master layer names")

# print(masterToEditID, masterToCopyID)

for glyph in font.glyphs:
    # set width var based on glyphToCopy layer width
    masterToCopyWidth = glyph.layers[masterToCopyID].width
    masterToEditWidth = glyph.layers[masterToEditID].width

    # check that widths are different
    if masterToCopyWidth != masterToEditWidth:

        for layer in glyph.layers:

            # go into the layer of the masterToEdit
            if layer.layerId == masterToEditID:

                
                # get left sidebearing
                LSB = layer.LSB

                # if masterToEditWidth != 0:

                # calculate proportion of as-is left sidebearing
                LSBProportional = LSB/masterToEditWidth

                ## set width based on masterToCopyWidth
                masterToEditNewWidth = masterToCopyWidth
                # layer.width = masterToEditNewWidth

                ## make sidebearings equal
                masterToEditNewLSB = float(int(LSBProportional*masterToEditNewWidth))
                
                # print(layer.parent.name)

                if printNewValues == True:
                    print(glyph.name)
                    print("\t masterToCopyWidth is " + str(masterToCopyWidth) + "\n" + "\t masterToEditWidth is " + str(masterToEditWidth) + "\n---")
                    print("\t masterToEditNewWidth is " + str(masterToEditNewWidth) + "\n" + "\t LSBProportional is " + str(LSBProportional))
                    print("\t oldLSB is " + str(LSB) + "\n" + "\t masterToEditNewLSB is " + str(masterToEditNewLSB))
                    print("=============")

                if setNewValues == True:
                    print(glyph.name, end=',')
                    layer.LSB = masterToEditNewLSB
                    layer.width = masterToEditNewWidth

                # print("\t masterToEditNewLSB is " + str(masterToEditNewLSB) +)

