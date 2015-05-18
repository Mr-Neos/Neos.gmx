if (debug_mode){
   debugout="Scriptcall:"+chr(9)+"sc_npc_setup "+chr(10);
   for(is=0;is<4;is+=1)
   {
       debugout=debugout+"argument"+string(is)+":"+chr(9)+string(argument[is])+chr(10);
   }
   show_debug_message(debugout);
}

act=false;
msg=ds_grid_create(0,0);
msgtmp=-1;                  //temporäres Grid

