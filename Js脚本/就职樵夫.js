var cga = require(process.env.CGA_DIR_PATH_UTF8+'/cgaapi')(function(){

	var task = cga.task.Task('就职樵夫', [
	{
		intro: '1.到法兰城内职业介绍所[193.51]找募集樵夫的阿空交谈并学习伐木体验技能。',
		workFunc: function(cb2){
			cga.travel.falan.toStone('E2', ()=>{
				cga.walkList([
					[195, 50, '职业介绍所'],
					[7, 10],
				], ()=>{
					cga.turnTo(8, 11);
					cga.AsyncWaitNPCDialog(()=>{
						cga.ClickNPCDialog(0, 0);
						cga.AsyncWaitNPCDialog(()=>{
							cga.ClickNPCDialog(0, -1);
							cga.AsyncWaitNPCDialog(()=>{
								var skill = cga.findPlayerSkill('伐木体验');
								if(!skill){
									cb2(new Error('伐木体验学习失败！可能钱不够？'));
									return;
								}
								cb2(true);
							});
						});
					});
				});
			});
		}
	},
	{
		intro: '2.学到技能后再到法兰城外的树旁使用伐木体验技能伐下20个孟宗竹。',
		workFunc: function(cb2){
			
			if(cga.needSupplyInitial({  })){
				cga.travel.falan.toCastleHospital(()=>{
					setTimeout(()=>{
						cb2('restart stage');
					}, 3000);
				});
				return;
			}
			
			cga.travel.falan.toStone('E', ()=>{
				cga.walkList([
					[281, 88, '芙蕾雅']
				], ()=>{
					var skill = cga.findPlayerSkill('伐木体验');
					cga.StartWork(skill.index, 0);
					var waitEnd = function(cb2){
						cga.AsyncWaitWorkingResult(()=>{
							var playerInfo = cga.GetPlayerInfo();
							if(playerInfo.mp == 0)
							{
								cb2(true);
								return;
							}								
							if(cga.getItemCount('孟宗竹') >= 20)
							{
								cb2(true);
								return;
							}
							var item = cga.getInventoryItems().find((it)=>{
								return ((it.name == '印度轻木' || it.name == '竹子') && it.count == 40)
							});
							if(item){
								cga.DropItem(item.pos);
							}
							cga.StartWork(skill.index, 0);
							waitEnd(cb2);
						}, 10000);
					}
					waitEnd(cb2);
				});
			});
		}
	},
	{
		intro: '3.带着伐下的孟宗竹回到法兰城内艾文蛋糕店[216.148]内找艾文交谈后就可以换到手斧。',
		workFunc: function(cb2){
			cga.travel.falan.toStone('E1', ()=>{
				cga.walkList([
					[216, 148, '艾文蛋糕店'],
					[11, 6],
				], ()=>{
					cga.turnTo(12, 5);
					cga.AsyncWaitNPCDialog(()=>{
						cga.ClickNPCDialog(32, -1);
						cga.AsyncWaitNPCDialog(()=>{
							cga.ClickNPCDialog(4, -1);
							cga.AsyncWaitNPCDialog(()=>{
								cb2(true);
							});
						});
					});
				});
			});
		}
	},
	{
		intro: '4.然后再到城内[106.190]的地点找樵夫弗伦（凌晨及白天出现）换取树苗。',
		workFunc: function(cb2){
			cga.travel.falan.toStone('S1', ()=>{
				cga.walkList([
					[107, 191],
					], ()=>{
					cga.task.waitForNPC('樵夫弗伦', ()=>{
						cga.turnTo(106, 191);
						cga.AsyncWaitNPCDialog((err, dlg)=>{
							if(dlg && dlg.options == 12){
								cga.ClickNPCDialog(4, -1);
								cga.AsyncWaitNPCDialog(()=>{
									cb2(true);
								});
							} else {
								cb2(false);
							}
						});
					});
				});
			});
		}
	},
	{
		intro: '5.利用白天时再把树苗交给种植家阿姆罗斯（134，36） 交给他之后就可以换取到水色的花。',
		workFunc: function(cb2){
			cga.travel.falan.toStone('S1', ()=>{
				cga.walkList([
					[134, 37],
				], ()=>{
					cga.task.waitForNPC('种树的阿姆罗斯', ()=>{
						cga.turnTo(134, 36);
						cga.AsyncWaitNPCDialog((err, dlg)=>{
							if(dlg && dlg.options == 12){
								cga.ClickNPCDialog(4, -1);
								cga.AsyncWaitNPCDialog(()=>{
									cb2(true);
								});
							} else {
								cb2(false);
							}
						});
					});
				});
			});
		}
	},
	{
		intro: '6.换到花之后再把他交给弗伦后就可以再换到木柴。 ',
		workFunc: function(cb2){
			cga.travel.falan.toStone('S1', ()=>{
				cga.walkList([
				[107, 191],
				], ()=>{
					cga.task.waitForNPC('樵夫弗伦', function(){
						cga.turnTo(106, 191);
						cga.AsyncWaitNPCDialog((err, dlg)=>{
							if(dlg && dlg.options == 12){
								cga.ClickNPCDialog(4, -1);
								cga.AsyncWaitNPCDialog(()=>{
									cb2(true);
								});
							} else {
								cb2(false);
							}
						});
					});					
				});
			});
		}
	},
	{
		intro: '7.拿着换到的木柴再回到法兰城的艾文蛋糕店[216.148]内找艾文交谈之后就可以换到点心。',
		workFunc: function(cb2){
			cga.travel.falan.toStone('E1', ()=>{
				cga.walkList([
					[216, 148, '艾文蛋糕店'],
					[11, 6]
				], ()=>{
					cga.turnTo(12, 5);
					cga.AsyncWaitNPCDialog(()=>{
						cb2(true);
					});
				});
			});
		}
	},
	{
		intro: '8.再把点心拿给弗伦后就可以换到樵夫推荐信。',
		workFunc: function(cb2){
			cga.travel.falan.toStone('S1', ()=>{
				cga.walkList([
				[107, 191],
				], ()=>{
					cga.task.waitForNPC('樵夫弗伦', ()=>{
						cga.turnTo(106, 191);
						cga.AsyncWaitNPCDialog(()=>{
							cb2(true);
						});
					});
				});
			});
		}
	},
	{
		intro: '9.最后再回到职业介绍所[193.51]内找樵夫荷拉巴斯说话后就可以就职。',
		workFunc: function(cb2){
			cga.travel.falan.toStone('E2', ()=>{
				cga.walkList([
					[195, 50, '职业介绍所'],
					[7, 10]
				], (r)=>{
					cga.TurnTo(7, 11);
					cga.AsyncWaitNPCDialog(()=>{
						cga.ClickNPCDialog(0, 0);							
						cga.AsyncWaitNPCDialog(()=>{
							cb2(true);
						});
					});
				});
			});
		}
	}
	],
	[//任务阶段是否完成
		function(){//伐木体验
			return (cga.findPlayerSkill('伐木体验')) ? true : false;
		},
		function(){//孟宗竹>=20
			return (cga.getItemCount('孟宗竹') >= 20) ? true : false;
		},
		function(){//手斧
			return (cga.getItemCount('#18179') > 0) ? true : false;
		},
		function(){//树苗
			return (cga.getItemCount('#18180') > 0) ? true : false;
		},
		function(){//水色的花
			return (cga.getItemCount('#18181') > 0) ? true : false;
		},
		function(){//木材
			return (cga.getItemCount('#18178') > 0) ? true : false;
		},
		function(){//艾文的饼干
			return (cga.getItemCount('#18212') > 0) ? true : false;
		},
		function(){//樵夫推荐信
			return (cga.getItemCount('樵夫推荐信') > 0) ? true : false;
		}
	]
	);
	
	task.doTask();
});