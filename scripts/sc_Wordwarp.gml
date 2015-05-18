if (debug_mode and false){
   debugout="Scriptcall:"+chr(9)+"sc_wordwarp "+chr(10);
   for(is=0;is<2;is+=1)
   {
       debugout=debugout+"argument"+string(is)+":"+chr(9)+string(argument[is])+chr(10);
   }
   show_debug_message(debugout);
}

if(is_string(argument0) and is_real(argument1))
{
    stri=string_replace_all(argument0,"\#",chr(31));//Baut Zeilenumbrüche in ein TMP Zeichen um 31
    stri=string_replace_all(stri,"#",chr(13)+chr(10));
    stri=string_replace_all(stri,chr(31),"\#");
    stri=string_replace_all(stri,chr(13)+chr(10),chr(13));
    stri=string_replace_all(stri,chr(10),chr(13));    
    sta=ds_list_create();
    count=string_lex_count(stri,chr(13));
    for(i=0;i<=count;i+=1)
    {
        ds_list_add(sta,string_lex_token(stri,chr(13),i));
    }
    //Jede Zeile Endspricht nun einem Listenplatz
    stb=ds_list_create();
    //for(i=0;i<ds_list_size(sta);i+=1)
    i=0;
    while(i<ds_list_size(sta))
    {
        acstr=ds_list_find_value(sta,i);
        if(string_width(acstr)>=argument1)
        {
            tmpa="";
            counter=string_lex_count(acstr," ");
            if(counter!=0)
            {
                if(string_width(string_lex_token(acstr," ",0))<argument1)
                {
                    //Mglk 1: Normaler Space Feed
                    show_debug_message("1");
                    j=0;
                    while(j<=counter)
                    {
                        //erstes Zeichen Löschen!
                        tmpb=tmpa+" "+string_lex_token(acstr," ",j);
                        if(string_width(tmpb)<argument1)
                        {
                            if(j!=0)
                            {
                                tmpa=tmpa+" "+string_lex_token(acstr," ",j);
                            }
                            else
                            {
                                tmpa=tmpa+string_lex_token(acstr," ",j);
                            }
                            j+=1;
                            show_debug_message(tmpa);
                        }
                        else
                        {
                            tmpb="";
                            for(k=j;k<=counter;k+=1)
                            {
                                if(k!=j)
                                {
                                    tmpb=tmpb+" "+string_lex_token(acstr," ",k);
                                }
                                else
                                {
                                    tmpb=tmpb+string_lex_token(acstr," ",k);
                                }
                            }
                            ds_list_replace(sta,i,tmpb);
                            i-=1;
                            show_debug_message("Break!");
                            break;
                        }
                    }
                    ds_list_add(stb,tmpa);
                }
                else
                {   //Mglk 2: Erster Teil Zu Lang
                    show_debug_message("2");
                    tmpa=string_lex_token(acstr," ",0);
                    tmpb="";
                    for(k=1;k<counter;k+=1)
                    {
                        if(k!=1)
                        {
                            tmpb=tmpb+" "+string_lex_token(acstr," ",k);
                        }
                        else
                        {
                            tmpb=tmpb+string_lex_token(acstr," ",k);
                        }
                    }
                    ds_list_replace(sta,i,tmpa);
                    ds_list_insert(sta,i,tmpb)
                    i-=1;                
                }
            }
            else
            {   //Mglk 3: Kein Leerzeichen
                show_debug_message("3");
                tmpa="";
                ct=1;
                acstr=string_replace_all(acstr,"\#","#");
                while(true)
                {
                    if(string_width((tmpa+string_char_at(acstr,ct)+"-"))<argument1)
                    {
                        tmpa=tmpa+string_char_at(acstr,ct);
                        ct+=1;
                    }
                    else
                    {
                        tmpa=tmpa+"-";
                        ds_list_add(stb,string_replace_all(tmpa,"#","\#"));
                        acstr=string_delete(acstr,1,string_length(tmpa)-1);
                        acstr=string_replace_all(acstr,"#","\#")
                        ds_list_replace(sta,i,acstr);
                        i-=1;
                        break;
                    }
                }
            }
        }
        else
        {
            //Mglk 4: Passt
            show_debug_message("4");
            ds_list_add(stb,acstr);
        }
        i+=1;
    }
    ds_list_destroy(sta);
    return stb;
}
