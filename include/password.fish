function genpass
	set combo {A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}

	if test (count $argv) = 1

		for i in (seq $argv[1])
            set index (math (random) '%' (math (count $combo) - 1) + 1)
            set rand_char $combo[$index]
			printf $rand_char
		end

        echo 

	else
		echo "Usage: genpass <length>"
		return 1
	end
end
