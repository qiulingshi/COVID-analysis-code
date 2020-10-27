#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>
#include<time.h>

#define M 1740000


typedef struct edge{
	int data;
	char transmit;	 
	struct edge *next;
}edge,*Edge;
 
typedef struct Node{
	int data;
	int degree;	 
	int t_thre;		 
	int threshold;	 
	char type;		 
	edge *next;
}Node;
 
typedef struct connect{
	int data;
	char type;
}connect;
 
void create(Edge head, int data)
{
	edge *r,*s;
	r=head;
	s=(edge *)malloc(sizeof(edge));
	s->data=data;
	if(head->next==NULL)
	{
		s->next=head->next;
		head->next=s;
	}
	else{
		while(head->next && head->next->data<data)
		{
			head=head->next;
		}
		s->next=head->next;
		head->next=s;
	}
}
 
void print(Edge head,char type[])
{
	FILE *fp;
	edge *p;
	char ch[10];
	strcpy(ch,"Graph_");
	strcat(ch,type);

	fp=fopen(ch,"a");


	p=head->next;
	while(p)
	{
		fprintf(fp,"%10d",p->data);
		p=p->next;
	}
	fprintf(fp,"\n");
	fclose(fp);
}
 
int del_Data(Edge head,int data)
{
	edge *p,*q;
	int k;

	q=head;
	p=head->next;
	while(p && p->data!=data)
	{
		q=p;
		p=p->next;
	}
	if(p==NULL)
	{
		return -1;
	}
	k=p->data;
	q->next=p->next;

	free(p);
	return k;
}
 
int length(Edge head)
{
	int count = 0;
	edge *h;
	h = head->next;
	while(h)
	{
		count++;
		h = h->next;
	}
	return count;
}
 
int find_Data(Edge head, int data)
{
	edge *h;
	h=head->next;
	while(h)
	{
		if(h->data==data)
			return 1;
		h=h->next;
	}
	return 0;
}
 
void count_Data(int array[M],float ct[M])
{
	int i;
	for(i=0;i<M;i++)
	{
		ct[i]=0;
	}
	for(i=0;i<M;i++)
	{
		ct[array[i]]=ct[array[i]]+1;
	}
}
 
void init_Node(Node ER[M])
{
	int i;
	for(i=0;i<M;i++)
	{
		ER[i].data=i;
		ER[i].degree=-1;
		ER[i].t_thre=0;
		ER[i].threshold=0; 
		ER[i].type='S';
		ER[i].next=(edge *)malloc(sizeof(edge));
		ER[i].next->next=NULL;
	}
}
 
void init_threshold(Node ER[M], int threshold)
{
	int i;
	edge *eg;
	
	for(i=0;i<M;i++)
	{ 
		ER[i].t_thre=0;
		ER[i].threshold=threshold;
		 
		eg=ER[i].next->next;
		while(eg)
		{
			eg->transmit='U';
			eg=eg->next;
		} 
	}
	
/*	FILE *fp;
	fp=fopen("threshold.txt","w");
	for(i=0;i<M;i++)
	{
		fprintf(fp,"%d,%d,%d\n",ER[i].threshold,ER[i].t_thre,ER[i].degree);
	}*/
}
  
void degree_Seq(Node SF[M], double alpha)
{ 
	int K;
	int i,j;
	int count=0;
	int u;
	float h;
	double seqence[M/2];   
	double CDD[M/2];      
	double zeta=0;    
	double rd;
	double rd_1;

	for(i=0;i<M/2;i++)
	{
		seqence[i]=0;
	}
	
	K=100;
	printf("K=%d\n",K);

	for(i=3;i<=K;i++)
	{ 
		seqence[i]=pow(i*1.0,-alpha); 
	    zeta=zeta+seqence[i];
	}
/*	for(i=3;i<=K;i++)
	{
		printf("\nseqence[%d]=%f",i,seqence[i]);
	}*/

	printf("zeta=%f\n",zeta);

	for(i=3;i<=K;i++)
	{
		seqence[i]=(seqence[i])/zeta;
	}

/*	for(i=3;i<=K;i++)
	{
		printf("\nseqence[%d]=%f",i,seqence[i]);
	}*/

	for(i=0;i<=M/2;i++)
	{
		CDD[i]=0;
	}

	for(i=3;i<=K;i++)
	{
		CDD[i]=CDD[i-1]+seqence[i];
	}

/*	for(i=3;i<=K;i++)
	{
		printf("\nCDD[%d]=%f",i,CDD[i]);
	}
*/
 
	srand((unsigned)time(NULL)); 
	for(i=0;i<M;i++)
	{
		rd=(float)rand()/(RAND_MAX);
		for(j=3;j<=K;j++)
		{
			if(rd<CDD[j])
			{
				h=(((double)j)/((double)5.1076))*((double)18);
				u=(int)h;
				rd_1=(float)rand()/(RAND_MAX);
				if(rd_1<h-u)
				{
					SF[i].degree=u+1;
				}
				else
				{
					SF[i].degree=u;
				}
				break;
			}
		}
	}
}

void degree_Seq_RR(Node SF[M], int deg)
{ 
	int i,j; 
	for(i=0;i<M;i++)
	{ 
		SF[i].degree=deg;
	}
}

 
void ER_Model(Node SF[M], char type[])
{
	int count=0; 

	int i,j;

	int ct1,ct2;

	int m,n;

	int seq[M*10];

	int temp;

	ct1=0;
	ct2=0;

	for(i=0;i<M;i++)
	{
		for(j=0;j<SF[i].degree;j++)
		{
			seq[count++]=i;
		}
	}
	for(i=0;i<count;i++)
	{
		printf("%4d",seq[i]);
	}
	printf("count=%d,seq[count]=%d",count,seq[count-1]);

	j=count;

	
	while(j>1)
	{
		m=rand()%j;
		n=rand()%j;
	//	printf("---------------------------------\n");
		while(m==n || find_Data(SF[seq[m]].next,seq[n]) || find_Data(SF[seq[n]].next,seq[m]) || seq[m]==seq[n])
		{
			m=rand()%j;
			n=rand()%j;
//			printf("---------\n");
		}
//				printf("\nj=%d",j);

		create(SF[seq[m]].next,seq[n]);
		create(SF[seq[n]].next,seq[m]);

		temp=seq[m];
		seq[m]=seq[j-1];
		seq[j-1]=temp;

		j--;

		temp=seq[n];
		seq[n]=seq[j-1];
		seq[j-1]=temp;

		j--;
	}
	printf("\nj=%d\n",j);
//	for(i=0;i<M;i++)
	{
//		print(SF[i].next,type);
	}
}

 
void inin_Infection_Node(Node ER[M], float q)
{  
	FILE *fp;
	int init_Node;
	int i;

	fp=fopen("seed.txt","r");
	while(!feof(fp))
	{
		fscanf(fp,"%d\n",&i); 
		ER[i].type='I';  
	}
	fclose(fp); 
}
 
void infection(Node ER[M], int threshold, float alpha, float r)
{
 
	int Old[M];		 
	int New[M];		 

	int count_Old=0;
	int count_New=0;

	int i;
	int k;

	int ct=0;
	int ct_S=0;
	int ct_I=0;
	int ct_R=0;

	int ct_Recover=0;
	
	int cascade_step;
	
	int flag;

	float rd_Infection;
	float rd_Recover;

	edge *p;

	FILE *fp;

	for(i=0;i<M;i++)
	{
		Old[i]=-1;
		New[i]=-1;
	}
 

	for(k=0;k<M;k++)
	{
		if(ER[k].type=='I')
		{
			Old[count_Old++]=k;
		}
	}
 

	cascade_step=0;

	int time_step=0;
	while(count_Old>0 || time_step<=20)
	{
		flag=0;
   
 		fp=fopen("Infective.txt","a");
 		fprintf(fp,"%d ",count_Old);
 		fclose(fp);
 
		for(i=0;i<count_Old;i++)
		{
			//printf("\nOld[%d]=%d,count_Old=%d",i,Old[i],count_Old);
			p=ER[Old[i]].next->next;
			while(p)
			{
				rd_Infection=rand()/(float)(RAND_MAX);
				if(rd_Infection<=alpha && ER[p->data].type=='S' && p->transmit=='U')
				{
					p->transmit='T';		//表示这条边已经传播了消息 ，因为传播不可逆，也就不必讲对应的边传播消息 
					ER[p->data].t_thre++;
					if(ER[p->data].t_thre>=threshold)
					{
						ER[p->data].type='I';
						New[count_New]=p->data;
						count_New++;
						flag=1;
					}	
				}
				p=p->next;
			}
		}
		
		if(flag==1)
		{
			cascade_step++;
		}

		//以概率r恢复
		for(i=0;i<count_Old;i++)
		{
			rd_Recover=rand()/(float)(RAND_MAX);
			if(rd_Recover<=r)
			{
				ct_Recover++;
				ER[Old[i]].type='R';
				Old[i]=Old[count_Old-1];
				Old[count_Old-1]=-1;
				i--;
				count_Old--;
			}
		}

 		fp=fopen("Recover.txt","a");
 		fprintf(fp,"%d ",ct_Recover);
 		fclose(fp);

 		fp=fopen("New_Inficted.txt","a");
 		fprintf(fp,"%d ",count_New);
 		fclose(fp);

		//将新感染的节点放入到Old数组中
		for(i=0;i<count_New;i++)
		{
			Old[count_Old]=New[i];
			count_Old++;
		}
		count_New=0;

		time_step++;
		if(time_step==3) //1-16
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;
		}

		if(time_step==4) //1-17
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;
		}

		if(time_step==5) //1-18
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 
		}

		if(time_step==6) //1-19
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;
		}

		if(time_step==7) //1-20
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;
		}

		if(time_step==8) //1-21
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 
		}

		if(time_step==9) //1-22
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 
		}

		if(time_step==10) //1-23
		{
			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i; 

			i=(rand()*rand())%M;
			ER[i].type='I'; 
			Old[count_Old++]=i;  
		} 
	}

	while(time_step<2000)
	{
		fp=fopen("Recover.txt","a");
 		fprintf(fp,"%d ",ct_Recover);
 		fclose(fp);

 		fp=fopen("New_Inficted.txt","a");
 		fprintf(fp,"%d ",count_New);
 		fclose(fp);

		fp=fopen("Infective.txt","a");
 		fprintf(fp,"%d ",count_Old);
 		fclose(fp);

		time_step++;
	}
	
 	fp=fopen("Recover.txt","a");
	fprintf(fp,"\n");
	fclose(fp);

	fp=fopen("New_Inficted.txt","a");
	fprintf(fp,"\n");
	fclose(fp);

	fp=fopen("Infective.txt","a");
	fprintf(fp,"\n");
	fclose(fp); 

	for(i=0;i<M;i++)
	{
		if(ER[i].type=='S')
			ct_S++;
		if(ER[i].type=='I')
			ct_I++;
		if(ER[i].type=='R')
			ct_R++;
	}
//	printf("\nct_S=%d,ct_I=%d,ct_R=%d",ct_S,ct_I,ct_R);

	fp=fopen("final_Infection.txt","a");
	fprintf(fp,"%d \n",ct_R);
	fclose(fp);
	
	fp=fopen("cascade_step.txt","a");
	fprintf(fp,"%d\n",cascade_step);
	fclose(fp);
}

int main()
{
	Node ER[M];
	int i,j,x;
	
	int threshold;
	
	float q;		//q表示初始时刻感染节点比例 

	FILE *fp;

	edge *eg;
	srand((unsigned)time(NULL));//随机种子

	init_Node(ER);
 	degree_Seq(ER, 3 );
//	degree_Seq_RR(ER, 18);   //构建平均度为15的网络
	ER_Model(ER,"ER.txt");
	
	fp=fopen("degree.txt","w");
	for(i=0;i<M;i++)
	{
		fprintf(fp,"%d\n",ER[i].degree);
	}
	fclose(fp);

	fp=fopen("network.pairs","w");
	for(i=0;i<M;i++)
	{
		eg=ER[i].next->next;
		while(eg)
		{
			fprintf(fp,"%d,%d\n",i,eg->data);
			eg=eg->next;
		}
	}
	fclose(fp);
	
	//初始时刻选择q比例节点的传播源 
//	q=0.1;
//	inin_Infection_Node(ER,	q);
	
	//初始化每个节点的固有阈值 .
	threshold=1;
	init_threshold(ER, threshold);
	
	for(x=0;x<100;x++)
	{
		printf("x=%d\n",x);
//		for(i=0;i<=300;i++)
		{
		//	for(q=0;q<=1;q=q+0.01)
			{ 
				for(j=0;j<M;j++)
				{
					ER[j].type='S';
				}
				inin_Infection_Node(ER,	q);
				init_threshold(ER, threshold);
				infection(ER, threshold, 0.106936,(18*0.106936)/1.64);
			}
		}
	}
	return 0;
}