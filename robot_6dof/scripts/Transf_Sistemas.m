function T = Transf_Sistemas(R, i, q)
  T = trotz(q)*transl(0,0,R.links(i).d)*transl(R.links(i).a,0,0)*trotx(R.links(i).alpha);
end


