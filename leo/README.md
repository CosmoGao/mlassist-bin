# CGA ��Ҷ�νű� QQ:158583461(��Ҷɢ��)  

- �������CGA��leoĿ¼��

- ��Ҫ���common.jsʹ��

- �������ܽű����������ò��ֲ���
    - �رշ�����  
    `leo.monitor.config.keepAlive = false;`
    
    - �Զ������Լ�  
    `leo.monitor.config.healSelf = true;`
    
    - װ������  
    ```
	leo.monitor.config.equipsProtect = true;
	leo.monitor.config.equipsProtectValue = 10;
    ```
    
    - �Զ���Ѫƿ(��ս��״̬)��������CGA���������Ϣ����
    ```
	leo.monitor.config.autoHp = true;
	leo.monitor.config.autoHpValue = 500;
	leo.monitor.config.autoHpItem = 'С��ʿ��ͥ��';
    ```
    
    - �Զ�������(��ս��״̬)��������CGA���������Ϣ����
    ```
	leo.monitor.config.autoMp = true;
	leo.monitor.config.autoMpValue = 350;
	leo.monitor.config.autoMpItem = 'ħ��֮Ȫ';
    ```

    - �޸������ٶȣ��ӳ���Ч��  
    `leo.panel.fightspd(200);`
    
- �޸�CGA������

    - ����Ĭ������  
    `leo.panel.default();`
    
    - ������������  
    `leo.panel.escape();`
    
    - ����ָ���ļ�����  
    `leo.panel.loadFromFile('�����ļ�����.json');`
    
    - �Զ�ս����塪���Զ�ս��  
    `leo.panel.autoBattle(true);`
    
    - �Զ�ս����塪������ս��  
    `leo.panel.highspeed(true);`
        
    - �Զ�ս����塪���������  
    `leo.panel.pet2action(true);`
        
    - �����Ϣ��塪���Զ�����  
    `leo.panel.autosupply(true);`
        
    - �����Ϣ��塪��������ͼ  
    `leo.panel.noswitchanim(120);`
        
    - �����Ϣ��塪�������ƶ�  
    `leo.panel.movespd(120);`
    
    - �����Ϣ��塪����������  
    `leo.panel.workacc(100);`
        
    - �����Ϣ��塪�����ٲɼ�  
    `leo.panel.workdelay(6000);`
        
    - ��Ʒ��Ϣ��塪������Զ�����  
    `leo.panel.itemdroplistAdd('ħʯ');`

    - ��Ʒ��Ϣ��塪��ɾ���Զ�����  
    `leo.panel.itemdroplistDel('ħʯ');`

    - ��Ʒ��Ϣ��塪������Զ��ѵ�(ע�⣬��Ҫ�з���|)  
    `leo.panel.itemtweaklistAdd('��֮��|20');`

    - ��Ʒ��Ϣ��塪��ɾ���Զ��ѵ�(ע�⣬��Ҫ�������õ�����ȫ��ͬ)  
    `leo.panel.itemtweaklistDel('��֮��|20');`

- ���õĺ���
    
    - ����̨������Ϣ��ӡ  
    `leo.baseInfoPrint();`
    
    - ����ͳ����Ϣ��ӡ  
    `leo.statistics();`
    
    - ����˵��  
    `leo.say('����');`
    
    - ����˵���Ϳ���̨��ӡ����(��ʱ���)  
    `leo.log('����');`
    
    - �ӳ��������飬����Ϊ��������  
    `leo.buildTeamBlock(5);`
    
    - ��Ա������飬����Ϊ�ӳ�����  
    `leo.enterTeamBlock(5);`
    
    - �л꣺�ж������Ƿ���꣬����ǳ�ȥ�л�  
    `leo.getBackSoul();`
    
    - ���ƣ��ж������Ƿ����ˣ����򵽷ɵ���ָ�����ֵ�ҽ��������Ҳ��������������ҽ��  
    `leo.healPlayer('ҽ������');`
    
    - ���ƣ��жϳ����Ƿ����ˣ�����ҽԺ���Ƴ���  
    `leo.healPet();`
    
    - ��ʿ��Ѫħ������(0-����2-�ϣ�4-����6-��)  
    `leo.supplyDir(����);`
    
    - ��ʿ��Ѫħ��x,yΪ��ʿ����(��ȴ�5��)  
    `leo.supply(x,y);`
    
    - �Ǳ��ɵ����һ�ʿ��Ѫħ(�ڰ���ɯ������л���ű��������ǲ����˳�û����Ѫħ����Ч)  
    `leo.supplyCastle();`
    
    - �Ǳ��ɵ�����ʯ(�ڰ���ɯ������л���ű��������ǲ���������ħʯ����Ч)  
    `leo.sellCastle();`
    
    - ����Ƿ���Ҫ�лꡢ����  
    `leo.checkHealth('ҽ������');`
    
    - ����Ƿ���Ҫ��ˮ����ʾ��Ϊ����100�;û�ˮ���ˮ��  
    `leo.checkCrystal('ˮ���ˮ����5��5��',100);`
    
    - ����Ƿ���Ҫ����ͷƽ��װ(����50�;û�)  
    `leo.autoEquipLv1('ƽ��');`
    
    - ħ���ƶ�(����Ҫ��Ч�Ż���Ч)���������ͣ�1-������ 2-ȡ���� 3-��ħ��  
    `leo.moveGold(ħ������,��������);`
    
    - �����ƶ���0~4��������λ�ã�100~104����λ��  
    `leo.movePet(ԭ����λ��,�µ�λ��);`
    
    - ����ȫ��  
    `leo.saveToBankAll();`
    
    - ����ȫȡ  
    `leo.getFormBankAll();`
    
    - �������(�ӳ���)������Ϊ��������������  
    `leo.encounterTeamLeader(protect);`
    
    - �������(��Ա��)������Ϊ��������������  
    `leo.encounterTeammate(protect);`
    
    - ������Ա��ƶ�1�񣨶ӳ�ʹ�ã������Ա���飩  
    `leo.moveAround();`
    
    - ʹ����Ʒ  
    `leo.useItemEx('��Ʒ����');`
    
    - ������Ʒ  
    `leo.dropItemEx('��Ʒ����');`
    
    - ��ͼ����ս����⣬����(0-����2-�ϣ�4-����6-��)  
    `leo.forceMoveEx(����,����);`
	
    - �˳��ű�  
    `leo.exit();`
    
    - �ǳ��س�  
    `leo.logBack();`

    - �ǳ���Ϸ  
    `cga.LogOut();`

    - �ж������Ƿ���ָ����Ʒ  
    `leo.has('ħ��֮Ȫ');`

    - ��ȡ��Ϸ���ʱ�䣬����['����','����','�ƻ�','ҹ��']  
    `leo.getSysTimeEx();`

    - ��ָ�������NPC�Ի���x,yΪNPC���꣬select�ǶԻ�ѡ��(Ĭ��ѡ��/ȷ��)��dest�ǶԻ�����ͼ�ж�  
    `leo.talkNpcAt(x,y,select,dest);`




