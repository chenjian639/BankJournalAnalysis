# config/database.py
import os
from typing import Dict, Any
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv  # 新增

# 加载.env文件中的环境变量
load_dotenv()

class DatabaseConfig:
    """数据库配置管理"""
    
    @staticmethod
    def get_db_config() -> Dict[str, Any]:
        """获取数据库配置"""
        return {
            'host': os.getenv('DB_HOST', 'localhost'),
            'user': os.getenv('DB_USER', 'your_username'),
            'password': os.getenv('DB_PASSWORD', 'your_password'),
            'database': os.getenv('DB_NAME', 'wos_data'),
            'port': int(os.getenv('DB_PORT', '3306'))  # 确保端口是整数
        }
    
    @staticmethod
    def get_engine():
        """创建SQLAlchemy引擎"""
        config = DatabaseConfig.get_db_config()
        connection_string = f"mysql+mysqlconnector://{config['user']}:{config['password']}@{config['host']}:{config['port']}/{config['database']}"
        return create_engine(connection_string)