CREATE TABLE IF NOT EXISTS pest_info (
    id INT PRIMARY KEY,
    category VARCHAR(50) COMMENT '害虫类别',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    description TEXT COMMENT '害虫描述',
    harm_level INT COMMENT '危害等级 1-5，5为最严重',
    image_url VARCHAR(255) COMMENT '害虫图片URL',
    name_en VARCHAR(100) COMMENT '害虫英文名',
    name_zh VARCHAR(100) COMMENT '害虫中文名',
    prevention_methods TEXT COMMENT '防治方法',
    symptoms TEXT COMMENT '危害症状',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT '害虫信息表';

INSERT IGNORE INTO pest_info (id, name_en, name_zh) VALUES
(0, 'no pest', '无昆虫'),
(1, 'rice leaf roller', '稻纵卷叶螟'),
(2, 'rice leaf caterpillar', '稻苞虫'),
(3, 'paddy stem maggot', '稻秆蝇'),
(4, 'asiatic rice borer', '三化螟'),
(5, 'yellow rice borer', '二化螟'),
(6, 'rice gall midge', '稻瘿蚊'),
(7, 'Rice Stemfly', '稻潜蝇'),
(8, 'brown planthopper', '褐飞虱'),
(9, 'white-backed planthopper', '白背飞虱');


UPDATE pest_info SET 
    category = '鳞翅目蛾科',
    description = '稻苞虫(Marasmia patnalis)是水稻叶卷虫的一种，主要分布于南亚和东南亚地区。其幼虫形态和取食行为与稻纵卷叶螟(Cnaphalocrocis medinalis)相似，常与其共同出现在稻田中，但发生程度较轻。' ,
    harm_level = 3,
    prevention_methods = '1. 农业防治：
   - 选用抗性品种，如Ptb 33、ASD5、TKM6等
   - 清除田边、沟边杂草，减少虫源
   - 加强肥水管理
2. 生物防治：
   - 保护天敌
   - 释放赤眼蜂
3. 化学防治：
   - 在幼虫孵化盛期施药
   - 可使用氟苯虫酰胺、氯虫苯甲酰胺等药剂' ,
    symptoms = '1. 幼虫在取食前会将叶片纵向卷起，用丝将叶缘缝合成筒状
2. 在卷叶内刮食叶肉的绿色组织，仅留表皮
3. 受害叶片呈现苍白色条纹
4. 严重时可导致叶片枯萎，影响水稻生长' 
WHERE id = 2;

UPDATE pest_info SET 
    category = '双翅目',
    description = '稻秆蝇(Chlorops oryzae)属双翅目黄潜叶蝇科，成虫体长2.3-3mm，体鲜黄色，头部背面有钻石形黑色斑。分布于黑龙江、浙江、江西、湖南、湖北、广东等省。在南方地区一年发生2-3代，寄主包括水稻、小麦、看麦娘等。' ,
    harm_level = 4,
    prevention_methods = '1. 农业防治：山区尽量不种单季稻，可抑制发生量。
2. 化学防治：
   - 成虫期：可喷洒80%敌敌畏乳油或50%杀螟松乳油。
   - 幼虫期：使用40%乐果乳油或50%杀螟松乳油喷雾。
   - 秧田处理：可使用3%克百威颗粒剂拌细土撒施。
   - 带卵秧苗：可用40%乐果乳油250倍液浸秧根1分钟。' ,
    symptoms = '1. 苗期受害心叶出现椭圆形或长条形小孔洞，后发展为纵裂长条状，叶片破碎。
2. 新叶扭曲或枯萎，受害株分蘖增多，植株矮化。
3. 抽穗延迟，穗小，秕谷增加。
4. 幼穗形成期受害出现扭曲的短小白穗，穗形残缺不全或出现花白穗。'
WHERE id = 3;

UPDATE pest_info SET 
    category = '双翅目瘿蚊科',
    description = '稻瘿蚊分布于我国台湾、福建、广东、广西、江西、湖南、贵州和云南南部等地区。成虫有趋光性，雌虫产卵量一般130-230粒，卵经过3-7天孵化幼虫。一年可发生6～8代，世代重叠。主害代是第4代、第5代，主要为害晚稻秧苗、大田分蘖期。' ,
    harm_level = 4,
    prevention_methods = '1. 农业防治：
   - 冬春期铲除田、塘、沟边杂草和野生稻，清除越冬虫源
   - 种植抗虫品种
   - 集中育秧，避免分散育秧
   - 加强肥水管理，培育壮秧
2. 化学防治：
   - 播种时可用吡虫啉拌种
   - 秧田期在播后4～8天或成虫羽化高峰期后3天施药
   - 大田防治在移栽返青至分蘖初期进行
   - 可选用噻嗪酮、毒死蜱等药剂喷雾防治' ,
    symptoms = '1. 幼虫吸食水稻生长点汁液，导致生长点不能正常发育
2. 受害稻苗基部膨大，心叶停止生长
3. 叶鞘部伸长形成淡绿色中空的葱管，向外伸形成"标葱"
4. 水稻从秧苗到幼穗形成期均可受害
5. 受害重的不能抽穗，几乎都形成"标葱"或扭曲不能结实
6. 严重发生时可导致绝收'
WHERE id = 6;

UPDATE pest_info SET 
    category = '双翅目水蝇科',
    description = '稻潜蝇（学名：Hydrellia griseola）分布于东北、华北、浙江等地。成虫体长2-3mm，青灰色，触角黑色，第3节扁平近椭圆形。卵长椭圆形，乳白色，上生细纵纹。末龄幼虫体长3-4mm，圆筒形略扁平，乳白色至乳黄色，尾端具黑褐色气门突起两个。',
    harm_level = 3,
    prevention_methods = '1. 农业防治：
   - 及时清除稻田杂草，减少虫源
   - 培育壮秧，保持浅水勤灌
   - 平整土地，确保稻苗在同一水层内健壮生长
   - 发生严重时可排水晒田，降低田间湿度
2. 化学防治：
   - 成虫发生盛期可使用2.5%敌百虫粉
   - 幼虫发生期可选用40%乐果乳油1000-1500倍液
   - 也可使用3%克百威颗粒剂拌细土撒施',
    symptoms = '1. 幼虫潜食叶肉，在上下表皮之间取食
2. 受害叶片呈现不规则的白色条斑
3. 受害处最初在叶面出现芝麻粒大小的弯曲"虫泡"
4. 随着虫道扩大和伸长，形成黄白色枯死斑
5. 稻株下部受害叶垂入田水，发生腐烂
6. 严重时可使稻苗成片枯萎，减产5%-10%，重者可达20%-30%'
WHERE id = 7; 


UPDATE pest_info SET 
    category = '鞘翅目象甲科',
    description = '稻水象甲是水稻生产上的一种重要灾害性害虫，为我国重大植物检疫性有害生物。成虫体长2.6-3.8mm，体宽1.5mm，体表被覆淡绿色鳞片，自前胸背板的一端至基部具有1个由黑色鳞片形成的广口瓶状暗斑，在鞘翅的基部向下延伸至鞘翅的约3/4处形成1个不整齐的黑斑。我国目前的稻水象甲均为雌虫，并以孤雌生殖方式进行繁殖。',
    harm_level = 5,
    prevention_methods = '1. 农业防治：
   - 把茭白、水稻地整平，控制周围灌溉排水
   - 田间尽量保持低水位至0.5cm，可减少成虫在水面下产卵
   - 分蘖后晒田，减少幼虫残存
   - 对来自疫区的稻草、牧草、草坪、腐植土等进行严格检查，防止侵入
2. 化学防治：
   - 每丛平均有虫0.5头时施用3%好年冬颗粒剂每亩4kg
   - 茭白田需保持水位1cm
   - 可使用残杀威、巴沙、巴丹等杀虫剂' ,
    symptoms = '1. 幼虫在水稻根内和根上取食，1-3龄幼虫蛀食根部
2. 4龄后爬出稻根直接咬食根系
3. 一般地块减小10%-20%
4. 严重地块减小可达50%-70%，甚至绝收
5. 幼虫食根，成虫食叶，一般造成水稻根系被毁40%至80%'
WHERE id = 11;

UPDATE pest_info SET 
    category = '同翅目飞虱科',
    description = '灰飞虱(Laodelphax striatellus)分布于东亚、东南亚、欧洲和北非等地。中国各省区均有发生，以长江中下游和华北稻区发生较多。成虫有长翅和短翅两型，长翅型雌虫体长4～4.2毫米，短翅型2.4～2.8毫米，全体淡黄褐或灰褐色。40°N以北年生4代，32°～40°N之间4～6代，28°～32°N之间5～6代。' ,
    harm_level = 3,
    prevention_methods = '1. 农业防治：
   - 选用抗虫品种
   - 加强肥水管理，做到基肥足、追肥早
   - 适期搁田，使水稻生长健壮
   - 提高抗虫性
2. 化学防治：
   - 每亩用25%扑虱灵可湿性粉剂30克
   - 或10%叶蝉散可湿性粉剂250克
   - 或50%混灭威乳油50毫升加水50千克喷雾
   - 也可用80%敌敌畏乳油每亩用150毫升拌细沙土20千克撒施' ,
    symptoms = '1. 成虫和若虫刺吸水稻汁液，虫量特大时引起黄叶以至枯死
2. 能传播稻、麦条纹叶枯病，稻、麦、玉米黑条矮缩病
3. 可能引起稻穗发黑、结实率下降
4. 喜分布在稻株上部叶片、叶鞘或稻穗
5. 分泌蜜露，易引起煤污病'
WHERE id = 10;


-- 更新部分害虫的详细信息
UPDATE pest_info SET 
    category = '鳞翅目螟蛾科',
    description = '稻纵卷叶螟(Cnaphalocrocis medinalis)是水稻重要迁飞性害虫。雌蛾体长8-9mm，翅展17mm，体翅黄褐色。分布于亚洲各产稻国、澳大利亚、非洲等地。每年随西南气流由中南半岛迁入，主迁入期为5月下旬至6月中旬。',
    harm_level = 4,
    prevention_methods = '1. 农业防治：
   - 合理施肥，控制氮肥使用
   - 科学管水，适当调节晒田时间
2. 物理防治：
   - 在化蛹高峰期灌深水2-3天，杀死虫蛹
3. 生物防治：
   - 在产卵盛期投放赤眼蜂，每亩每次3-4万头，隔3天1次，连续3次
   - 喷洒杀螟杆菌、青虫菌
4. 化学防治：
   - 在幼虫2-3龄盛期进行防治
   - 可用80%杀虫单粉剂或42%特力克乳油喷雾' ,
    symptoms = '1. 幼虫吐丝将稻叶纵卷成筒，在苞内取食叶肉
2. 受害叶片形成白条斑，仅留一层表皮
3. 严重时全苞枯白，使全田呈现一片枯白
4. 尤其在为害剑叶和倒二叶时，常造成不实谷'
WHERE id = 1;

UPDATE pest_info SET 
    category = '半翅目',
    description = '柑橘蚜是柑橘类作物的主要害虫，通过刺吸式口器吸食植物汁液',
    harm_level = 4,
    prevention_methods = '1. 物理防治：悬挂黄色粘虫板；2. 生物防治：利用瓢虫等天敌；3. 化学防治：喷施高效低毒农药',
    symptoms = '吸食嫩叶和嫩梢汁液，导致叶片卷曲变黄，影响植株生长，并能传播病毒病'
WHERE id = 90;

UPDATE pest_info SET 
    category = '双翅目',
    description = '柑橘大实蝇是柑橘类水果的重要害虫，幼虫蛀食果肉',
    harm_level = 5,
    prevention_methods = '1. 物理防治：套袋、诱捕；2. 农业防治：及时清除落果；3. 化学防治：喷施药剂防治成虫',
    symptoms = '幼虫钻入果实内部取食果肉，造成果实腐烂，引起大量落果'
WHERE id = 86;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '柑橘潜叶蛾是柑橘树的重要害虫，幼虫潜入叶片表皮下取食',
    harm_level = 3,
    prevention_methods = '1. 农业防治：修剪病虫叶；2. 生物防治：保护天敌；3. 化学防治：新梢期喷药防治',
    symptoms = '幼虫在叶片表皮下潜行取食，形成弯曲的潜道，影响光合作用'
WHERE id = 89;

UPDATE pest_info SET 
    category = '半翅目',
    description = '红蜡蚧是柑橘的主要害虫之一，通过刺吸危害植物',
    harm_level = 4,
    prevention_methods = '1. 物理防治：人工刮除虫体；2. 生物防治：利用寄生蜂；3. 化学防治：冬季喷施农药',
    symptoms = '吸食枝叶汁液，导致叶片发黄脱落，枝条生长衰弱，严重时可致树枯死'
WHERE id = 79;

UPDATE pest_info SET 
    category = '蔬菜害虫',
    description = '斜纹夜蛾(Spodoptera litura)属鳞翅目夜蛾科，是一种暴食性害虫。主要为害芋、十字花科、茄科、瓜类蔬菜、甘薯等作物。在华北地区每年发生4-5代，长江流域5-6代，福建6-9代。成虫昼伏夜出，幼虫有假死性，当食料不足时有成群迁移的习性。',
    harm_level = 4,
    prevention_methods = '1. 农业防治：及时翻犁空闲田，铲除田边杂草；在幼虫入土化蛹高峰期进行中耕灭蛹；合理安排种植茬口，避免寄主作物连作。
2. 物理防治：成虫发生期在田间设置黑光灯，或使用杨树枝把、糖醋液诱杀成虫。
3. 人工防治：在产卵高峰期至初孵期，人工摘除卵块和初孵幼虫为害叶片。
4. 化学防治：在卵块孵化到3龄幼虫前喷药，建议在午后和傍晚进行，可使用阿维菌素、氯虫苯甲酰胺等药剂。',
    symptoms = '1. 初孵幼虫群集为害，啃食叶肉留下表皮，呈窗纱透明状。
2. 3龄以上幼虫分散危害，造成叶片缺刻。
3. 4龄幼虫进入暴食阶段，咬食叶片仅留主脉，占全幼虫期总食量的90%以上。
4. 在包心菜类上，幼虫可钻入叶球内危害，造成内部空洞和粪便污染。'
WHERE id = 87;

UPDATE pest_info SET 
    category = '鞘翅目',
    description = '芒果象甲是芒果的重要害虫，成虫取食果实',
    harm_level = 4,
    prevention_methods = '1. 农业防治：套袋、清园；2. 物理防治：诱捕成虫；3. 化学防治：适时喷药',
    symptoms = '成虫在果实表面啃食，造成果实表面凹陷，影响商品价值'
WHERE id = 101;

UPDATE pest_info SET 
    category = '半翅目',
    description = '稻叶蝉是水稻主要害虫之一，主要包括黑尾叶蝉、电光叶蝉和白翅叶蝉等。成虫具有趋光性和趋嫩性，能飞善跳。在华南地区一年可发生5-7代，世代重叠。不仅直接危害水稻，还能传播水稻矮缩病、黄矮病等多种病毒病。' ,
    harm_level = 4,
    prevention_methods = '1. 农业防治：铲除田间、田埂上的杂草，减少虫源；合理密植，避免偏施氮肥。
2. 物理防治：成虫盛发期利用杀虫灯进行诱杀。
3. 化学防治：可选用噻虫嗪、吡虫啉、吡蚜酮、呋虫胺等药剂，在秧苗2-3叶期及移栽前2-3天喷施，分蘖盛期再喷洒一次。',
    symptoms = '1. 成若虫在稻株茎秆下部危害，早晚在上部叶片取食，被害叶片出现白色或棕褐色条斑。
2. 受害稻株生长缓慢，叶片发黄，严重时叶片干枯，稻株枯死。
3. 穗期危害时，其排泄物受霉菌污染可致稻穗表面产生黑色霉层，形成"黑穗"症状。
4. 灌浆期受害严重的，可形成半白穗，籽粒空瘪。'
WHERE id = 12;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '草地贪夜蛾是玉米的重要害虫，对玉米等作物造成严重危害',
    harm_level = 5,
    prevention_methods = '1. 农业防治：合理密植，适时收获；2. 生物防治：释放天敌；3. 化学防治：科学用药',
    symptoms = '啃食玉米叶片致枯黄，攻击玉米花丝导致果穗缺粒，严重影响产量和品质'
WHERE id = 15;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '玉米螟是玉米主要害虫之一，全生育期均可为害玉米',
    harm_level = 4,
    prevention_methods = '1. 农业防治：秋季深耕，清除秸秆；2. 生物防治：使用赤眼蜂；3. 化学防治：适期喷药',
    symptoms = '心叶期蛀食叶肉造成花叶，抽穗后钻蛀茎秆影响生长，穗期蛀食雌穗和嫩粒'
WHERE id = 16;

UPDATE pest_info SET 
    category = '果树害虫',
    description = '桃蛀螟是一种多食性害虫，寄主包括桃、梨、杏、李、苹果等果树，以及玉米、高粱等作物。幼虫主要钻蛀果实危害，不仅影响果实发育，而且在果内排泄粪便，严重影响果实品质。',
    harm_level = 4,
    prevention_methods = '1. 及时摘除树上僵果，捡拾树下干、僵、病、虫果实，集中烧毁或深埋
2. 利用频振杀虫灯、性诱剂或糖醋酒液诱杀成虫
3. 在果实表面喷施辛硫磷乳油或氯虫苯甲酰胺等药剂
4. 释放赤眼蜂等天敌进行生物防治',
    symptoms = '1. 果实被钻蛀，形成蛀孔
2. 果实内部被取食，有虫道和粪便
3. 受害果实变色、脱落
4. 影响果实产量、品质和商品价值'
WHERE id = 27;

UPDATE pest_info SET 
    category = '蔬菜害虫',
    description = '小菜蛾是十字花科蔬菜的主要害虫，世代重叠现象严重。',
    harm_level = 3,
    prevention_methods = '1. 农业防治：合理轮作，清理田园。
2. 物理防治：使用灯光诱杀。
3. 生物防治：使用生物农药。',
    symptoms = '幼虫取食叶片，造成孔洞。'
WHERE id = 17;

UPDATE pest_info SET 
    category = '直翅目',
    description = '蝗虫是多种禾本科作物的共同害虫，危害面积广',
    harm_level = 5,
    prevention_methods = '1. 农业防治：清除杂草，破坏虫卵；2. 生物防治：保护鸟类天敌；3. 化学防治：及时喷药防治',
    symptoms = '成虫群体迁飞，集中啃食作物叶片，造成减产，严重时导致绝收'
WHERE id = 30;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '棉铃虫是棉花的主要害虫之一，危害棉铃和棉花其他部位',
    harm_level = 4,
    prevention_methods = '1. 农业防治：清洁田园，及时打顶；2. 生物防治：套种玉米诱集产卵；3. 化学防治：科学用药',
    symptoms = '幼虫钻入棉铃取食，造成棉铃受损，影响棉花产量和品质'
WHERE id = 40;

UPDATE pest_info SET 
    category = '蛛形纲',
    description = '棉叶螨（红蜘蛛）是棉花重要害虫，通过刺吸危害植物',
    harm_level = 4,
    prevention_methods = '1. 农业防治：合理灌溉，增加湿度；2. 生物防治：保护天敌；3. 化学防治：喷施杀螨剂',
    symptoms = '叶片被吸食后失绿、变黄、干枯，重者落叶，影响棉花生长发育'
WHERE id = 41;

UPDATE pest_info SET 
    category = '鞘翅目',
    description = '大豆食心虫是大豆主要害虫，以幼虫蛀食危害',
    harm_level = 4,
    prevention_methods = '1. 农业防治：选用抗性品种，适时播种；2. 物理防治：深耕灭蛹；3. 化学防治：适期用药',
    symptoms = '幼虫钻入豆荚取食子粒，造成豆荚受损，影响大豆产量和品质'
WHERE id = 50;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '菜青虫（菜粉蝶幼虫）是十字花科蔬菜的主要害虫，食量大且繁殖快',
    harm_level = 4,
    prevention_methods = '1. 农业防治：清除杂草和病残株；2. 生物防治：利用赤眼蜂等天敌；3. 化学防治：低龄期使用生物源农药',
    symptoms = '2龄前仅啃食叶肉留下透明表皮，3龄后可食整片叶片，严重时仅剩叶脉，并污染叶片'
WHERE id = 60;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '小菜蛾是十字花科蔬菜的主要钻蛀性害虫，世代重叠，抗药性强',
    harm_level = 4,
    prevention_methods = '1. 物理防治：使用防虫网和诱虫灯；2. 生物防治：使用生物农药；3. 化学防治：轮换使用不同药剂',
    symptoms = '幼虫潜叶取食，造成隧道状食痕，后期钻心取食，导致植株腐烂'
WHERE id = 61;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '甜菜夜蛾是多种蔬菜的重要害虫，食性杂，夜间活动',
    harm_level = 4,
    prevention_methods = '1. 农业防治：深翻土地，清除病残体；2. 物理防治：利用杀虫灯诱杀；3. 化学防治：低龄期集中防治',
    symptoms = '幼虫咬食叶片，3龄以上可钻食果实，造成落果烂果，严重影响产量和品质'
WHERE id = 62;

UPDATE pest_info SET 
    category = '水稻害虫',
    description = '稻纵卷叶螟是一种重要的水稻害虫。幼虫将叶片纵向卷起筑成虫巢，并在其中取食叶肉，造成条状或块状白色透明的食痕。',
    harm_level = 4,
    prevention_methods = '1. 及时清除田间杂草，减少虫源。
2. 合理密植，增施钾肥，增强水稻抗性。
3. 发生初期喷洒高效氯氰菊酯、氟虫腈等药剂防治。
4. 利用灯光诱杀成虫。',
    symptoms = '1. 叶片被纵向卷起，形成管状
2. 叶片出现条状或块状白色透明食痕
3. 被害叶片枯萎
4. 严重时整株叶片卷曲，影响光合作用'
WHERE id = 11;

UPDATE pest_info SET 
    category = '鳞翅目',
    description = '玉米螟是玉米主要害虫，幼虫钻蛀茎秆和果穗',
    harm_level = 5,
    prevention_methods = '1. 农业防治：秋季深耕，清除秸秆；2. 生物防治：释放赤眼蜂；3. 化学防治：适时喷药防治',
    symptoms = '幼虫蛀食茎秆，造成倒伏，钻入果穗危害籽粒，造成严重减产'
WHERE id = 23;

UPDATE pest_info SET 
    category = '半翅目',
    description = '蚜虫是多种农作物的共同害虫，通过刺吸式口器吸食植物汁液',
    harm_level = 3,
    prevention_methods = '1. 生物防治：利用瓢虫等天敌；2. 物理防治：喷水冲洗；3. 化学防治：喷洒低毒农药',
    symptoms = '吸食植物汁液，导致叶片卷曲、变黄，分泌蜜露引起煤污病'
WHERE id = 25;

UPDATE pest_info SET 
    category = '蔬菜害虫',
    description = '甜菜夜蛾是一种世界性害虫，主要为害甘蓝、花椰菜、白菜、萝卜等蔬菜。',
    harm_level = 3,
    prevention_methods = '1. 农业防治：合理轮作，清理田园杂草。
2. 物理防治：使用黑光灯诱杀成虫。
3. 生物防治：使用生物农药如Bt。',
    symptoms = '幼虫食叶成缺刻或孔洞，严重时把叶片吃光，仅剩叶柄、叶脉。'
WHERE id = 15;

UPDATE pest_info SET 
    category = '鳞翅目螟蛾科',
    description = '三化螟（Scirpophaga incertulas）是水稻重要钻蛀性害虫，幼虫专一危害水稻，蛀食茎秆导致“枯心”“白穗”。成虫体长10-12mm，雌蛾灰黄色，雄蛾灰褐色，具趋光性。一年发生2-5代，以幼虫在稻桩内越冬。',
    harm_level = 5,
    prevention_methods = '1. 农业防治：\n   - 及时处理稻草和稻桩，减少越冬虫源\n   - 推广抗虫品种（如IR36、IR64）\n   - 适时晒田，破坏幼虫生存环境\n2. 生物防治：\n   - 释放赤眼蜂寄生卵\n   - 喷洒Bt菌或白僵菌\n3. 化学防治：\n   - 在卵孵化高峰期喷施氯虫苯甲酰胺、阿维菌素等药剂',
    symptoms = '1. 幼虫蛀入稻茎，导致苗期“枯心”、孕穗期“白穗”\n2. 茎秆基部可见蛀孔及虫粪\n3. 严重时稻株成片枯死，减产30%以上'
WHERE id = 4;

UPDATE pest_info SET 
    category = '鳞翅目螟蛾科',
    description = '二化螟（Chilo suppressalis）广泛分布于亚洲稻区，幼虫危害水稻、玉米、甘蔗等作物。成虫体长12-15mm，雌蛾黄褐色，雄蛾灰褐色。一年发生2-7代，以幼虫在稻桩或茎秆内越冬，危害症状与三化螟相似但更耐低温。',
    harm_level = 4, 
    prevention_methods = '1. 农业防治：\n   - 冬季翻耕稻田，破坏幼虫越冬场所\n   - 选用抗虫品种（如中早39、天优华占）\n2. 物理防治：\n   - 灯光诱杀成虫\n3. 化学防治：\n   - 在分蘖期和孕穗期喷施四氯虫酰胺、甲维盐等药剂',
    symptoms = '1. 幼虫蛀食稻茎，造成“枯心苗”和“白穗”\n2. 茎秆内虫道较长，常有多个幼虫共存\n3. 后期稻株易倒伏，千粒重下降'
WHERE id = 5;

UPDATE pest_info SET 
    category = '半翅目飞虱科',
    description = '褐飞虱（Nilaparvata lugens）是水稻毁灭性害虫，专一危害水稻。成虫长翅型体长4-5mm，短翅型2.5-3mm，雌虫淡褐色，雄虫黑褐色。具迁飞性，繁殖力强，分泌蜜露引发煤污病，并传播水稻条纹叶枯病。',
    harm_level = 5,
    prevention_methods = '1. 农业防治：\n   - 避免过量施氮肥，控制群体密度\n   - 选用抗虫品种（如IR56、甬优15）\n2. 生物防治：\n   - 保护蜘蛛、青蛙等天敌\n3. 化学防治：\n   - 低龄若虫期喷施噻嗪酮、吡蚜酮等药剂',
    symptoms = '1. 成虫和若虫群集稻株基部刺吸汁液，致叶片发黄、枯卷\n2. 严重时整株枯死，呈“冒穿”状\n3. 茎秆基部变黑腐烂，稻穗不实率增加'
WHERE id = 8;

UPDATE pest_info SET 
    category = '半翅目飞虱科',
    description = '白背飞虱（Sogatella furcifera）是水稻重要害虫，与褐飞虱共生但危害较轻。成虫体长3-4mm，背部具明显白色纵纹，具趋光性和远距离迁飞能力。主要通过刺吸危害并传播水稻南方黑条矮缩病毒（RSV）。',
    harm_level = 4,
    prevention_methods = '1. 农业防治：\n   - 合理密植，避免田间郁闭\n   - 清除田边杂草减少虫源\n2. 物理防治：\n   - 使用黄色粘虫板诱杀\n3. 化学防治：\n   - 喷施呋虫胺、烯啶虫胺等新型药剂',
    symptoms = '1. 若虫和成虫危害稻株基部，致叶片褪绿发黄\n2. 分泌蜜露诱发煤污病，影响光合作用\n3. 传播病毒病导致植株矮缩、稻穗畸形'
WHERE id = 9;